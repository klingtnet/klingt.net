.. title: How to enable IPv6 on your Ubuntu droplet
.. slug: how-to-enable-ipv6-on-your-ubuntu-droplet
.. date: 2014-12-18 10:02:49 UTC+01:00
.. tags: IPv6, droplet, digitalocean, ubuntu, nginx
.. link:
.. description: How to enable IPv6 on your Ubuntu 14.04 droplet and how to set it up in nginx.
.. type: text

In `one of my previous posts </posts/klingtnet-goes-ssl-and-spdy/>`_ I showed how to enable IPv6 in nginx, but I haven't tested it. I thought it's enough to enable it in my droplet settings, setup the ``AAAA`` DNS record and add the IPv6 listen directive to the nginx configuration. Today I've checked through `ipv6-test.com <http://ipv6-test.com/validate.php>`_ if `klingt.net <https://www.klingt.net>`_ is reachable via IPv6 and to my surprise it wasn't. The problem was the missing ``inet6`` address entry in the network interface configuration ``/etc/network/interface``.

Setup your network interface
----------------------------

At first go to your droplet settings page and write down your public IPv6 *address* and *gateway*.

.. image:: /imgs/droplet_settings.png

SSH into your droplet and before making the settings permanent, try them out by using ``ip addr`` like this:

.. code:: bash

    ip -6 addr add PUBLIC_IPv6/SUBNET_MASK dev INTERFACE
    ip -6 route add default via PUBLIC_IPv6_GATEWAY dev INTERFACE

- ``INTERFACE`` will be `eth0` in most cases, you can view your interfaces with ``ip -6 addr show``
- everything else is viewed in your droplet settings

Now you should be able to ping your machine ``ping6 -c 2 PUBLIC_IPv6``. If the output looks similar to this, you're almost done:

.. code:: bash

    $ ping6 -c 2 2a03:f00:2:ba9::17d:c001
    PING 2a03:f00:2:ba9::17d:c001(2a03:f00:2:ba9::17d:c001) 56 data bytes
    64 bytes from 2a03:f00:2:ba9::17d:c001: icmp_seq=1 ttl=56 time=33.8 ms
    64 bytes from 2a03:f00:2:ba9::17d:c001: icmp_seq=2 ttl=56 time=37.1 ms

    --- 2a03:f00:2:ba9::17d:c001 ping statistics ---
    2 packets transmitted, 2 received, 0% packet loss, time 1001ms
    rtt min/avg/max/mdev = 33.808/35.464/37.120/1.656 ms

Make the settings permanently by adding them to your `/etc/network/interfaces` config file:

.. code:: bash

    iface eth0 inet6 static
        address 2a03:f00:2:ba9::17d:c001:c001
        netmask 64
        gateway 2a03:f00:2:ba9::1
        autoconf 0
        dns-nameservers 2001:4860:4860::8888 2001:4860:4860::884

The ``dns-nameservers`` entries are the `public google dns server addresses <https://developers.google.com/speed/public-dns/docs/using>`_.

DNS
~~~

If you haven't done it yet, add an ``AAAA`` record to your DNS settings and let it point to the *public IPv6 address* of your droplet. This could take some time until it is promoted, but in my case it has worked almost instantly.

nginx
~~~~~

Now you have to add the listen directives to your nginx website config, ``listen [::]:80;`` for plain ol' HTTP and ``listen [::]:443 ssl spdy;`` if you are `a cool kid </posts/klingtnet-goes-ssl-and-spdy/>`_.

Please remember to restart your nginx to make the changes take effect: ``service nginx restart``.

Firewall
~~~~~~~~

If you have a firewall installed make sure that *port 80 and 443 is open*. If you have enabled IPv6 in your ``/etc/default/ufw`` this was already done.

Have fun with IPv6!