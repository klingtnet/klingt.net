.. title: Blog Setup Part 1 - Digitalocean
.. slug: blog-setup-part-1-digitalocean
.. date: 2014-11-12 20:34:32 UTC+01:00
.. tags: digitalocean, vps, ufw, nginx, subdomains, ubuntu
.. link:
.. description: The configuration of my digitalocean droplet that serves this blog.
.. type: text
.. draft: True

`klingt.net™ <http://www.klingt.net>`_ is back after a long time and this isn't the first post, but nevertheless I will show you in the first part of this series how this blog is served. In the second part I will describe how I configured `nikola`_ and made my custom blog theme using `sass`_.

I've investigated different webhosters before I went to digitalocean, including `uberspace`_, and a VPS at `1und1`_. Uberspace was fast, SSH access was possible, they had a nice and helpful service and the best thing, you could pay what you want. The main disadvantage was, that you won't get root permission, because they are selling a shared webhosting service. The virtual private server at 1und1 had nice specs and was super cheap, at least for students, which means 1€ per year. But, regardless of the specs, their VPS was nearly half as fast as my 5$ Droplet [1]_, it took almost an hour to setup a new machine, they use custom linux images without `docker`_ support and the machine managment website was a mess.

After the bad experience with 1und1 I wanted to try out digitalocean because the people around me always recommended it and second because of the `Student Developer Pack <https://education.github.com/pack>`_ from `GithubEducation <https://education.github.com/>`_.

Before creating the droplet there was the choice of the OS. Currently they are supporting Ubuntu, Debian, CentOS and CoreOS. Unfortunately they don't provide `Arch <https://www.archlinux.org/>`_ anymore, so I decided to choose `Ubuntu <http://www.ubuntu.com/>`_ in version 14.10. Additionally you can specify the datacenter of your droplet, which is Amsterdam in my case. After that it's time to setup your SSH public key on the webinterface for the machine or to `generate a new key-pair <https://help.github.com/articles/generating-ssh-keys/>`_. Now you can ssh into your new droplet and change the timezone according to your location using ``dpkg-reconfigure tzdata``.

nginx
=====

A website is nothing without a webserver so I had to make a choice between `Apache`_ and `nginx`_. For both of them it should be an more than easy task to serve some static content, which is what they have to do for this website, so it's more a matter of personal preferences. I've choosen nginx because the configuration seems to be much easier and the cool kids use it 😎. The `official documentation <http://wiki.nginx.org/Install>`_ has got instructions for all kinds of operating systems and because my droplet runs Ubuntu I will only give the instructions for this system[2]_:

.. code:: sh

    add-apt-repository ppa:nginx/stable
    apt-get update
    apt-get install nginx

It's also a good time to upgrade your packages: ``apt-get update && apt-get upgrade``.

Before I began to configure the webserver I've read about the common `nginx pitfalls`_. One thing they've said in that article, was to distrust every article on the web about nginx configuration. That's what you should do also with this post.

The first thing to do, is to make a folder for each website that should be served. This is one my weblog and another one for my reports that are generated from the nginx logs via `goaccess`_.

.. code:: sh

    mkdir -p /var/www/klingt.net/html/{blog,reports}

I've changed the ownership of the freshly created directories to ``www-data`` user and group.

.. code:: sh

    chown -R www-data:www-data /var/www/klingt.net

Nginx provides a sample configuration file that you can use as a basis for your *server blocks* or virtual host in Apache terms. To put it simply, a server block is a combination of server-name and ip/port indication.

.. code:: sh

    cp /etc/nginx/sites-available/default /etc/nginx/sites-available/klingt.net

Now we have a copy of the base configuration file that you can edit with the editor of your choice. We only need the last part that begins with ``Virtual Host configuration for example.com``. It's good practice to serve your website from ``www.domain.example`` as well as ``domain.example``. It's possible to configure are redirect via `http status code 301 <http://www.wikiwand.com/en/HTTP_301>`_ from the ``www`` subdomain to the root domain or to add both urls to the ``server_name`` parameter, which is what I've done. My droplet has IPv6 enabled, so I have to add listen directive for this to: ``listen [::]:80``. I also had to change the ``root`` path to the directory I've created before: ``root /var/www/klingt.net/html/blog`` (remember to close all commands with an ``;``).
Now the configuration file should look something like this:

.. code-block:: sh
    :linenos:

    server {
        listen 80;
        listen [::]:80;

        server_name klingt.net www.klingt.net;

        root /var/www/klingt.net/blog;
        index index.html index.htm;

        location / {
            try_files $uri $uri/ =404;
        }
    }

If you haven't done it before, you should now set the ``A`` and ``AAAA`` (IPv6) records of your domain to point to the IP address of your droplet. When you've done that you can make symlink from the config-file to nginx ``sites-enabled`` directory:

.. code:: sh

    ln -s /etc/nginx/sites-available/klingt.net /etc/nginx/sites-enabled/klingt.net

Restart nginx ``service nginx restart`` and your website should be served!

.. nginx log analytics
.. -------------------

.. - goaccess
.. - ``openssl passwd`` (max. 8 characters)
.. - edit /etc/goaccess.conf , date-format and logfile
.. - create cronjob for html report:
..     + ``crontab -e``
..     + ``*/10 * * * * /root/scripts/goaccess_reports.sh``

.. optimization
.. ------------

.. - use `PageSpeed Insights`_
.. - enable compression/uncompression `nginx compression`_
.. - text/plain for rst ``/etc/nginx/mime.types``
.. - enable caching
.. - service nginx restart

.. - configure `ufw`_

..     + IPV6 should be enabled by default, if you don't want this change IPV6 to no in /etc/default/ufw
..     + ``ufw default deny incoming``
..     + ``ufw default allow outgoing``
..     + ``ufw allow ssh`` (same as ``ufw allow 22/tcp``)
..     + ``ufw allow www``
..     + ``sudo ufw enable``


.. [#] That's how they call virtual machines at `digitalocean`_
.. [#] You could also use ``ppa:nginx/development`` if you are brave enough.

.. _ufw: https://www.digitalocean.com/community/tutorials/how-to-setup-a-firewall-with-ufw-on-an-ubuntu-and-debian-cloud-server
.. _PageSpeed Insights: https://developers.google.com/speed/pagespeed/insights/
.. _Apache: http://httpd.apache.org/
.. _goaccess: http://goaccess.io/
.. _nginx: http://nginx.org/
.. _nginx pitfalls: http://wiki.nginx.org/Pitfalls
.. _nginx compression: http://nginx.com/resources/admin-guide/compression-and-decompression/
.. _uberspace: https://uberspace.de/
.. _1und1: http://hosting.1und1.de/hosting?linkId=hd.mainnav.webhosting.home
.. _docker: https://www.docker.com/
.. _digitalocean: https://www.digitalocean.com
.. _sass: http://sass-lang.com/
.. _nikola: http://getnikola.com/
