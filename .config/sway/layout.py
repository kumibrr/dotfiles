#!/usr/bin/python3
#
# awesome sway layout manager.
#
# Requires 1.5 https://github.com/swaywm/sway/pull/4949
# See ppa:simpoir/ppa for a package.
#
# Add to your sway config:
#   exec layout.py
#   # swap with master win
#   bindsym $mod+Control+Return nop layout swap main
#   # Move your focus around
#   bindsym $mod+$left nop layout left
#   bindsym $mod+$right nop layout right
#   bindsym $mod+$up nop layout up
#   bindsym $mod+$down nop layout down
#   bindsym $mod+$down nop layout output next
#   bindsym $mod+$down nop layout output prev
#
# Improvements:
# - multiple layouts (horizontal, monocle, full)
# - navigating floats

import fcntl
import functools
import logging.handlers
import os
import signal
import sys

import i3ipc
import xdg.BaseDirectory

DEFAULT_SIZE = 60
LOCKPATH = os.path.join(xdg.BaseDirectory.get_runtime_dir(), "sway_layout")

LOG = logging.getLogger("sway_layout")


class NothingToDoProbably(AssertionError):
    """Some assumptions about having a state are incorrect, so do nothing."""


def catchNop(fun):

    @functools.wraps(fun)
    def wrapped(*args, **kwargs):
        try:
            fun(*args, **kwargs)
        except NothingToDoProbably:
            return

    return wrapped


def check(res):
    """Run a command, print an Exception."""
    for i in res:
        if i.error:
            LOG.error(i.error)


class Layout:

    def __init__(self, c):
        self._c = c
        try:
            self.do(c)
        except NothingToDoProbably:
            pass

    def _ws(self, c):
        tree = c.get_tree()
        focused = tree.find_focused()
        if not focused:
            raise NothingToDoProbably
        return focused.workspace()

    @property
    def stack(self):
        # Assuming leaves are in some kind of order.
        return self._ws(self._c).leaves()

    def do(self, c):
        w = self._ws(self._c)
        leaves = w.leaves()
        if not leaves:
            return

        main = leaves[0]
        check(main.command("layout splith"))
        check(main.command("mark --replace main"))

        try:
            col = leaves[1]
        except IndexError:
            return
        # Condition is to avoid moving everything if we don't have to.
        reparented = False
        if len(main.parent.nodes) < 2 \
                or col.id not in [i.id
                                  for i in main.parent.nodes[1].descendants()]:
            LOG.info("reparent column")
            col.command("move to mark main")
            reparented = True
        col.command("splitv")
        col.command("mark --replace col")

        for leaf in leaves[2:]:
            leaf.command("move to mark col")
            leaf.command("mark --replace col")

        if reparented:
            # Avoid glitchy clients race of not receiving the new size while
            # their window is being created.
            # import time
            # time.sleep(0.1)
            main.command(f"resize set width {DEFAULT_SIZE} ppt")

    @catchNop
    def on_win(self, c, e):
        stack = self.stack
        if e.change in ("new", "close"):
            if e.change == "new" and len(stack) > 2:
                # bump new to end of stack
                self.stack[-1].command("mark --replace col")
                new_id = e.container.id
                self._c.command(f"[con_id={new_id}] move to mark col")

            self.do(c)
        else:
            return

    def swap(self, c):
        check(self.stack[0].command("mark main"))
        check(c.command("swap container with mark main"))
        check(c.command("mark --replace main"))

    def on_bind(self, c, e):
        cmd = e.binding.command
        if cmd == "nop layout swap main":
            self.swap(c)
        if cmd == "nop layout up":
            self.focus_next(c, -1)
        if cmd == "nop layout down":
            self.focus_next(c, 1)
        if cmd == "nop layout left":
            self.resize(c, -20)
        if cmd == "nop layout right":
            self.resize(c, 20)
        if cmd == "nop layout output next":
            self.focus_next_output(c)
        if cmd == "nop layout output prev":
            self.focus_next_output(c, -1)

    def focus_next(self, c, jump=1):
        ws = self._ws(c)
        stack = [x.id for x in self.stack]
        try:
            current = ws.find_focused().id
        except AttributeError:
            # no focused window.
            return
        try:
            idx = stack.index(current)
        except ValueError:
            # window is not in stack. probably floating or stashed.
            return
        new = stack[(idx + jump) % len(stack)]
        check(c.command(f"[con_id={new}] focus"))

    def focus_next_output(self, c, jump=1):
        wss = [w for w in c.get_workspaces() if w.visible]
        for i, w in enumerate(wss):
            if w.focused:
                break
        else:
            raise NothingToDoProbably("no focused workspace?")

        wanted = wss[(i + jump) % len(wss)].output
        check(c.command(f"focus output {wanted}"))

    def resize(self, c, add):
        check(self.stack[0].command(f"resize grow right {add} px"))


def setup_log():
    logging.basicConfig()
    LOG.setLevel(logging.INFO)
    LOG.addHandler(logging.handlers.SysLogHandler())


def detach_process():
    if os.fork():
        sys.exit(0)


def kill(path):
    with open(path, encoding="ascii") as lock:
        os.kill(int(lock.read()), signal.SIGTERM)
    os.unlink(path)
    sys.exit(0)


def main(argv):
    if "-k" in argv:
        return kill(LOCKPATH)

    if "--fg" not in argv:
        detach_process()
    setup_log()

    with open(LOCKPATH, "a") as lock:
        try:
            fcntl.lockf(lock, fcntl.LOCK_EX + fcntl.LOCK_NB)
            lock.truncate(0)
            print(os.getpid(), file=lock, flush=True)
        except OSError:
            LOG.critical(f"Failed to lock {LOCKPATH!r}.")
            sys.exit(1)

        try:
            c = i3ipc.Connection()
            ll = Layout(c)
            c.on(i3ipc.Event.WINDOW, ll.on_win)
            c.on(i3ipc.Event.BINDING, ll.on_bind)
            c.main()
        except Exception as e:
            LOG.critical("Unexpected failure", exc_info=e)
        finally:
            os.unlink(LOCKPATH)


if __name__ == "__main__":
    main(sys.argv)