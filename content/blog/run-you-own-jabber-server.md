{
    "date": "2015-01-30",
    "description": "How to run your own Jabber server, using prosody.",
    "slug": "run-you-own-jabber-server",
    "tags": "jabber, XMPP, prosody, erlang, ubuntu, digitalocean, Lua, prosody",
    "title": "Run you own Jabber server"
}

Every [Jabber](http://en.wikipedia.org/wiki/Jabber) [^1] server that I
used previously, let it be [jabber.org](http://www.jabber.org/) or
[jabber.de](http://www.jabber.de/), had suffered from occasional
downtimes, thus I decided to setup my own Jabber server.

eJabberd or Prosody?
====================

At first I tried to use [eJabberd](https://www.ejabberd.im/), which is
written in
[Erlang](http://en.wikipedia.org/wiki/Erlang_%28programming_language%29)
and a good choice if you want to serve hundreds of users, but the
configuration was a mess. The latest eJabberd version, to which the
[documentation](http://www.process-one.net/docs/ejabberd/guide_en.html)
refers to, uses a new [YAML](http://en.wikipedia.org/wiki/YAML) style
configuration syntax, the older version from the Ubuntu repositories on
the other hand uses Erlang syntax for the configuration file.

Due to the configuration issues and because it felt like a little bit of
overkill to run an eJabberd server for 1-10 users I decided to try out
an alternative. My choice fell on [Prosody](http://prosody.im/), a
[Lua](http://en.wikipedia.org/wiki/Lua_%28programming_language%29) XMPP
server. Its configuration is written in Lua as well, but even that I
didn't used this language before, it felt quite familiar for me as a
python developer.

Installation
============

I will describe the installation and configuration steps for Prosody
rather briefly, if something remains unclear, try to find an answer in
the [official configuration guide](http://prosody.im/doc/configure). I
will assume that you are owning an [SSL
certificate](/posts/klingtnet-goes-ssl-and-spdy/), if not you can omit
the `ssl` block in the configuration and use unencrypted connections.
Since a lot of XMPP servers are requiring encrypted connections
(including mine) you won't be able to communicate with them using
unencrypted connections.

-   `apt-get install prosody` or install it [from
    source](http://prosody.im/doc/install#source), if you like
-   the initial example config file is very well documented, that's why
    you should back it up before making any changes:
    `cp /etc/prosody/prosody.cfg.lua{,.bak}`
-   open the `/etc/prosody/prosody.cfg.lua` file in your favorite editor
    (vim 😸 ) [^2]
-   Prosody differentiates between **global** and **local settings**,
    *local is everything inside a VirtualHost block* and *global
    everything outside*
-   add a host:

```lua
VirtualHost "example.domain"
    enabled = true

    -- if you want to use ssl
    ssl = {
        key = "/path/to/your/keyfile.pem";
        certificate = "/path/to/your/certificate.crt";
        --uncomment the next line if your keyfile is password protected
        --password = "password";
    }
```

-   I removed the global key/certificate config
-   make sure that **prosody is able read the key** and the
    **certificate**:
    `sudo -u prosody cat /path/to/{keyfile.pem,certificate.crt}`
-   

    also make sure that the permissions allow the `prosody` user to enter the directory:

    :   -   on ubuntu the prosody user is part of the `ssl-cert` group
        -   the path to my keyfile and the keyfiles itself are owned by
            `root:ssl-cert` and set to `710`, that means owner has all
            permissions and everyone in the group (`ssl-cert`) is able
            to execute (enter) the directory
        -   every keyfile has `640` permissions, this translates to
            `rw`-permissions for the owner and `r` for the group

-   force clients to use encryption: `c2s_require_encryption = true`
-   to force secured server to server connections as well:
    `s2s_secure_auth = true`
-   use the authentification backend that stores only password hashes
    instead of plaintext: `authentication = "internal_hashed"`
-   add an useraccount for yourself:
    `prosodyctl register user example.domain password` or interactive
    `prosodyctl adduser user@domain.name` [^3]
-   \[*optional*\] add your user to the list of admins:
    `admins = { "user@example.domain" }`
-   restart the prosody service: `service prosody restart`
-   \[*ufw*\] enable both ports for incoming and outcoming connections:
    `ufw allow 5222/tcp` and `ufw allow 5269/tcp`

Everything should work fine, have fun with your own Jabber server!

**UPDATE** (Sa 19. Mär 17:32:37 CET 2016)

I no longer maintain my [prosody docker
image](https://github.com/klingtnet/docker-prosody) but there are some
good alternatives:

-   at first the [official prosody docker
    image](https://github.com/prosody/prosody-docker)
-   and then there is [Mark Kubacki's prosody
    image](https://hub.docker.com/r/wmark/prosody/) which incorporates
    `lua-pbkdf2` and `lua-sec` build against
    [BoringSSL](https://boringssl.googlesource.com/boringssl/). See this
    [github issue](https://github.com/klingtnet/klingt.net/issues/2)
    for details.

[^1]: The [XMPP](http://en.wikipedia.org/wiki/XMPP) protocol was
    originally named Jabber, so you can use both names interchangeably.

[^2]: You can syntax check your config file everytime by running
    `luac -p /etc/prosody/prosody.cfg.lua`.

[^3]: Note that you can run shell commands in vim with `:! cmd`.
