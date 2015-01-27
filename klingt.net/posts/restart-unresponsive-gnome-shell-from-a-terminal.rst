.. title: Restart unresponsive gnome-shell from a terminal
.. slug: restart-unresponsive-gnome-shell-from-a-terminal
.. date: 2015-01-27 15:01:48 UTC+01:00
.. tags: gnome, shell, desktop, frozen, unresponsive, restart, tty, terminal
.. link: 
.. description: How to restart a frozen gnome-shell from a virtual terminal (tty).
.. type: text

To restart your gnome shell you can press ``Alt+F3`` to open the *run command prompt* and type ``r`` restart it. 

.. image:: /imgs/gnome-shell_run.png

But what do you do if your gnome-shell got completly stuck? If your computer isn't crashed you should be able to login into one of the `virtual terminals <http://en.wikipedia.org/wiki/Terminal_emulator>`_ (tty's). On Arch you can access them via ``Ctrl+Alt+Fx``, where ``x`` is a number between 2 and 6 (at least on my machine). Now you only need to send a `SIGINT` signal to your `gnome-shell` process:

```sh
kill -s INT $(pidof gnome-shell)
```

Now you can logout from your tty and switch back to your gnome-shell with ``Ctrl+Alt+F1``
