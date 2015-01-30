.. title: Run you own Jabber server
.. slug: run-you-own-jabber-server
.. date: 2015-01-30 11:25:52 UTC+01:00
.. tags: jabber, XMPP, prosody, erlang, ubuntu, digitalocean, Lua, prosody
.. link:
.. description: How to run your own Jabber server, using prosody.
.. type: text

Every `Jabber <http://en.wikipedia.org/wiki/Jabber>`_ [1]_ server that I used previously, let it be `jabber.org <http://www.jabber.org/>`_ or `jabber.de <http://www.jabber.de/>`_, had suffered from occasional downtimes, thus I decided to setup my own Jabber server.

eJabberd or Prosody?
--------------------

At first I tried to use `eJabberd <https://www.ejabberd.im/>`_, which is written in `Erlang <http://en.wikipedia.org/wiki/Erlang_%28programming_language%29>`_ and a good choice if you want to serve hundreds of users, but the configuration was a mess. The latest eJabberd version, to which the `documentation <http://www.process-one.net/docs/ejabberd/guide_en.html>`_ refers to, uses a new `YAML <http://en.wikipedia.org/wiki/YAML>`_ style configuration syntax, the older version from the Ubuntu repositories on the other hand uses Erlang syntax for the configuration file.

Due to the configuration issues and because it felt like a little bit of overkill to run an eJabberd server for 1-10 users I decided to try out an alternative. My choice fell on `Prosody <http://prosody.im/>`_, a `Lua <http://en.wikipedia.org/wiki/Lua_%28programming_language%29>`_ XMPP server. Its configuration is written in Lua as well, but even that I didn't used this language before, it felt quite familiar for me as a python developer.

Installation
------------

I will describe the installation and configuration steps for Prosody rather briefly, if something remains unclear, try to find an answer in the `official configuration guide <http://prosody.im/doc/configure>`_. I will assume that you are owning an `SSL certificate </posts/klingtnet-goes-ssl-and-spdy/>`_, if not you can omit the ``ssl`` block in the configuration and use unencrypted connections. Since a lot of XMPP servers are requiring encrypted connections (including mine) you won't be able to communicate with them using unencrypted connections.

- ``apt-get install prosody`` or install it `from source <http://prosody.im/doc/install#source>`_, if you like
- the initial example config file is very well documented, that's why you should back it up before making any changes: ``cp /etc/prosody/prosody.cfg.lua{,.bak}``
- open the ``/etc/prosody/prosody.cfg.lua`` file in your favorite editor (vim 😸 ) [2]_
- Prosody differentiates between **global** and **local settings**, *local is everything inside a VirtualHost block* and *global everything outside*
- add a host:

.. code:: lua

    VirtualHost "example.domain"
        enabled = true

        -- if you want to use ssl
        ssl = {
            key = "/path/to/your/keyfile.pem";
            certificate = "/path/to/your/certificate.crt";
            --uncomment the next line if your keyfile is password protected
            --password = "password";
        }

- I removed the global key/certificate config
- make sure that **prosody is able read the key** and the **certificate**: ``sudo -u prosody cat /path/to/{keyfile.pem,certificate.crt}``
- also make sure that the permissions allow the ``prosody`` user to enter the directory:
    - on ubuntu the prosody user is part of the ``ssl-cert`` group
    - the path to my keyfile and the keyfiles itself are owned by ``root:ssl-cert`` and set to ``710``, that means owner has all permissions and everyone in the group (``ssl-cert``) is able to execute (enter) the directory
    - every keyfile has ``640`` permissions, this translates to ``rw``-permissions for the owner and ``r`` for the group
- force clients to use encryption: ``c2s_require_encryption = true``
- to force secured server to server connections as well: ``s2s_secure_auth = true``
- use the authentification backend that stores only password hashes instead of plaintext: ``authentication = "internal_hashed"``
- add an useraccount for yourself: ``prosodyctl register user example.domain password`` or interactive ``prosodyctl adduser user@domain.name`` [3]_
- [*optional*] add your user to the list of admins: ``admins = { "user@example.domain" }``
- restart the prosody service: ``service prosody restart``
- [*ufw*] enable both ports for incoming and outcoming connections: ``ufw allow 5222/tcp`` and ``ufw allow 5269/tcp``

Everything should work fine, have fun with your own Jabber server!

----

.. [1] The `XMPP <http://en.wikipedia.org/wiki/XMPP>`_ protocol was originally named Jabber, so you can use both names interchangeably.
.. [2] You can syntax check your config file everytime by running ``luac -p /etc/prosody/prosody.cfg.lua``.
.. [3] Note that you can run shell commands in vim with ``:! cmd``.
