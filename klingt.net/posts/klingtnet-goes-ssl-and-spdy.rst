.. title: klingt.net goes SSL and SPDY
.. slug: klingtnet-goes-ssl-and-spdy
.. date: 2014-12-01 22:00:52 UTC+01:00
.. tags: SPDY, SSL, TLS, HTTP/2, digitalocean, nginx, HTTPS, namecheap, CSR
.. link:
.. description: How I've setup SSL and enabled SPDY in nginx on my digitalocean droplet.
.. type: text

.. role:: strike
    :class: strike

Today I stumbled across `HTTPvsHTTPS <https://www.httpvshttps.com/>`_, which compares both protocols by loading 360 images via each one of them and telling you the time difference as result. I was really impressed how fast `SPDY <http://en.wikipedia.org/wiki/SPDY>`_ was, in comparision to plain old HTTP, more than 4x faster to give you a number. SPDY enforces encryption via `SSL/TLS <http://en.wikipedia.org/wiki/Transport_Layer_Security>`_ , which means that you will get *more security* (plus speed) and I am in need for an SSL certificate.

The certificate
---------------

It so happens that there is a coupon for a one year certificate from `namecheap <https://www.namecheap.com/>`_ on `github's education pack <https://education.github.com/pack/>`_, after this period it costs about 7€ per year, this should be affordable for anyone. To get the certificate I had to enter a `Certificate Signing Request <http://en.wikipedia.org/wiki/Certificate_signing_request>`_ (CSR) which I've generated like this: ``openssl req -newkey rsa:2048 -keyout example.com.pem -out example.com.csr``. Because it's not obvious I will explain what every parameter means with help of ``man openssl`` and ``man req``:

- ``req`` use PKCS#10 X.509 Certificate Signing Request (CSR) Management
- ``rsa:2048`` generate a 2048-bit key using the RSA algorithm
- ``-keyout example.com.pem`` filename for the generated private key
- ``-out example.com.csr`` filename for CSR output

The following dialog will ask you for a passphrase to encrypt your private key, please note the you have to enter it every time your webserver restarts. If you don't want this, then you have to add the ``-nodes`` option. But be warned, this leaves the private.key *unencrypted*! Depending on your certification authority you have to do some more steps until you receive the signed certificate. My certificate was delivered via email, so I had to upload it securely to my server using ``scp`` for example. An unencrypted FTP connection is :strike:`not` never a good idea :strike:`in this case`.

You can specify an ``ssl_password_file`` in your `nginx config <http://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate_key>`_ if you are lazy.

nginx
-----

Now it's time to edit your site-config that should be located somewhere like ``/etc/nginx/sites-available/example.com``.
Because the HTTPS port is ``443`` you have to add one or two ``listen`` directives, dependend on if you will support IPv6 or not [1]_.

.. code:: nginx

    listen 443 ssl spdy;
    listen [::]:443 ssl spdy;

Remember to *open the port in your firewall* or you will look like an idiot, trust me...

SSL is nothing without certificates, that means you have to add their location to. Before adding the certificates you may have to take a look on the instructions of your certification authority, because it can be necessary to concatenate multiple certificates into one file, f.e. ``cat ROOTCA.key example.com.key > bundle.key``.

.. code:: nginx

    ssl_certificate /file/path/klingt.net/bundle.crt;
    ssl_certificate_key /file/path/server.key;

That's all, have fun, feel secure and be SPDY!

Rewrite-Rule
~~~~~~~~~~~~

Now that we have SSL enabled we can rewrite all the incoming HTTP requests to HTTPS, using the following config:

.. code:: nginx

    server {
        listen 80;
        listen [::]:80;
        server_name example.com www.example.com;
        return 301 https://www.example.com$request_uri;
    }

    server {
        listen 443 ssl spdy;
        listen [::]:443 ssl spdy;

        ssl_certificate /file/path/example.com/bundle.crt;
        ssl_certificate_key /file/path/server.key;

        ssl_protocols  TLSv1 TLSv1.1 TLSv1.2;   # don’t use SSLv3 because of the POODLE attack

        server_name example.com www.example.com;

        #...
    }

Update
~~~~~~

- *2014-12-09* Disabled SSL3 in ``nginx.conf`` because of the vulnerability through the `POODLE attack <http://en.wikipedia.org/wiki/POODLE>`_ (no, not the `fancy haired dogs <http://upload.wikimedia.org/wikipedia/commons/4/4c/Poodle%2C_cropped.JPG>`_). Thanks to Tobias for giving me this advise. You can check your settings with `this online-tool <https://www.ssllabs.com/ssltest/>`_.

----

.. [#] You should have a good reason for not supporting IPv6 in 2014.

