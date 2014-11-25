.. title: From Dropbox to Syncthing
.. slug: from-dropbox-to-syncthing
.. date: 2014-11-25 19:36:07 UTC+01:00
.. tags: file synchronization, dropbox, syncthing, go
.. link:
.. description: Why I switched from Dropbox to Syncthing and how I organized my synchronized folders.
.. type: text

I've used `Dropbox`_ since about two and a half years on my desktop and mobile devices and was pretty satisfied with it most of the time. But, even before `Condoleezza Rice <https://blog.dropbox.com/2014/04/growing-our-leadership-team/>`_ [1]_ was part of Dropbox's directors board, I had a bad feeling about my data lying on their servers. Another downside was the linux client, fortunately it's not half as bad as `skype <http://www.skype.com/de/download-skype/skype-for-linux/>`_. The trayicon always disappeared under `Gnome3 <http://www.gnome.org/gnome-3/>`_, clicking on a single notification opened up a dozen instances of `Nautilus <https://github.com/GNOME/nautilus>`_ and using closed-source software means that I had to install it manually or use it from the `Arch User Repository <https://wiki.archlinux.org/index.php/Arch_User_Repository>`_ which I try to avoid whenever possible. Also the android client seems to forget my login credentials from time to time.

One might say that I only had to encrypt my Dropbox folder in order to reduce my worries about security. That's what I've done and it works well using `EncFS <http://en.wikipedia.org/wiki/EncFS>`_ as long as you don't use your Dropbox on different Operating Systems, especially on mobile. Distrusting a service provider and at the same time using a service that he offers is wrong from the ground up.

Not everything was bad, the synchronization worked well and I can't remember a moment when their servers were down. Getting public links for my files was also a nice feature. The camera upload feature was also a nice addition.

Besides the security point of view I would have really liked to share folders only with read access and to get a lot more storage space. I could have solved the last two points with a premium account but this wasn't an option because I had enough unused server resources.

I thought about using `Seafile`_ or `ownCloud`_, but both need a central server to work and the latter is written in `php <http://php.net/>`_, that is reason enough for me to avoid it.


.. image:: /imgs/syncthing_dashboard.png
    :class: kn-image
    :alt: the syncthing dashboard

.. code-block::

     syncthing
        ├── audio
        ├── docs
        ├── dump
        ├── edu
        ├── gfx
        │   ├── Pixel
        │   └── Vector
        ├── mobile
        ├── shares
        │   ├── LT
        │   └── uni
        │        ├── andreas
        │        ├── _common
        │        └── lucas
        ├── sprd
        └── wallpaper

----

.. [#] I didn't mispelled her name, she is `written like that <http://en.wikipedia.org/wiki/Condoleezza_Rice>`_

.. _Dropbox: https://www.dropbox.com/
.. _ownCloud: http://owncloud.org/
.. _Seafile: http://seafile.com/en/home/
.. _Syncthing: http://syncthing.net/