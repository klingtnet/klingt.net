.. title: Run you own Jabber server
.. slug: run-you-own-jabber-server
.. date: 2015-01-27 20:21:52 UTC+01:00
.. tags: jabber, XMPP, prosody, erlang, ubuntu, digitalocean
.. link: 
.. description: How to run your own Jabber server, using prosody.
.. type: text

Prosody
-------

- `Prosody <http://prosody.im/>`_ is an XMPP server written in Lua
- install via apt-get: `apt-get install prosody`
- `official configuration guide <http://prosody.im/doc/configure>`_
- backup the original config ``cp /etc/prosody/prosody.cfg.lua{,.bak}``
- open ``/etc/prosody/prosody.cfg.lua`` in your favorite editor
- you can syntax check your config file by running ``luac -p /etc/prosody/prosody.cfg.lua``
- add a host:

.. code:: lua

    VirtualHost "klingt.net"
        enabled = true

        -- if you want to use ssl
        ssl = {
            key = "/path/to/your/keyfile.pem";
            certificate = "/path/to/your/certificate.crt";
            --password = "password";
        }

- make sure that prosody can read the key and cert file: ``sudo -u prosody cat /path/to/keyfile.pem``
- the permissions must also allow the user to enter the folder beginning from root
- Prosody knows global and local settings, *local is everything inside a VirtualHost block* and *global everything outside*
- use the authentification backend that stores only password hashes instead of plaintext: ``authentication = "internal_hashed"``
- add an useraccount for yourself: ``prosodyctl register user example.domain password`` or interactive ``prosodyctl adduser user@domain.name``
- ``service prosody restart``
- ``ufw allow 5222/tcp`` und zum empfangen ``ufw allow 5269/tcp``

- force clients to use encryption: ``c2s_require_encryption = true``
- to force servers as well: ``s2s_secure_auth = false``


eJabberd (remove)
-----------------

- install ``apt-get install ejabberd``
- allow connections for the predefined `port <http://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml?search=xmpp>`_ ``ufw allow 5280/tcp``
- open ``/etc/ejabberd/ejabberd.cfg`` with your favorite text editor:

.. code:: yaml

    %% Admin user
    {acl, admin, {user, "root", "domain.name"}}.

    %% Hostname
    {hosts, ["domain.name"]}.


- ``service ejabberd restart``
- create an admin account (the name ``admin`` is reserved): ``ejabberdctl register root domain.name password``
- open ``domain.name:5280/admin`` in your browser and enter your admin username ``root@domain.name`` and password of your admin account

