{
    "date": "2014-11-19",
    "description": "The configuration of my digitalocean droplet that serves this blog.",
    "slug": "blog-setup-part-1-digitalocean",
    "tags": "digitalocean, vps, ufw, nginx, subdomains, ubuntu",
    "title": "Blog Setup Part 1 - Digitalocean"
}

[klingt.net™](http://www.klingt.net) is back after a long time and this
isn't the first post, but nevertheless I will show you in the first part
of this series how this blog is served. In the second part I will
describe how I configured [nikola](http://getnikola.com/) and made my
custom blog theme using [sass](http://sass-lang.com/).

I've investigated different webhosters before I went to digitalocean,
including [uberspace](https://uberspace.de/), and a VPS at
[1und1](http://hosting.1und1.de/hosting?linkId=hd.mainnav.webhosting.home).
Uberspace was fast, SSH access was possible, they had a nice and helpful
service and the best thing, you could pay what you want. The main
disadvantage was, that you won't get root permission, because they are
selling a shared webhosting service. The virtual private server at 1und1
had nice specs and was super cheap, at least for students, which means
1€ per year. But, regardless of the specs, their VPS was nearly half as
fast as my 5\$ Droplet \[1\]\_, it took almost an hour to setup a new
machine, they use custom linux images without
[docker](https://www.docker.com/) support and the machine managment
website was a mess.

After the bad experience with 1und1 I wanted to try out digitalocean
because the people around me always recommended it and second because of
the [Student Developer Pack](https://education.github.com/pack) from
[GithubEducation](https://education.github.com/).

Before creating the droplet there was the choice of the OS. Currently
they are supporting Ubuntu, Debian, CentOS and CoreOS. Unfortunately
they don't provide [Arch](https://www.archlinux.org/) anymore, so I
decided to choose [Ubuntu](http://www.ubuntu.com/) in version 14.10.
Additionally you can specify the datacenter to use, which is Amsterdam
in my case. After that it's time to setup your SSH public key on the
webinterface for the droplet or to [generate a new
key-pair](https://help.github.com/articles/generating-ssh-keys/). Now
you should be able to ssh into your new droplet and change the timezone
according to your location using `dpkg-reconfigure tzdata` (quite
obvious command for changing the timezone … ).

nginx
=====

A website is nothing without a webserver, so I had to make a choice
between [Apache](http://httpd.apache.org/) and
[nginx](http://nginx.org/). They are both full-blown webservers, so the
choice is more a matter of personal preferences. Lastly I've decided to
give nginx a chance because the configuration seems to be much easier
(and the cool kids use it 😎). The [official
documentation](http://wiki.nginx.org/Install) has got installation
instructions for all kinds of operating systems, but my droplet runs
Ubuntu, so I will write only the instructions for this system \[2\]\_:

```bash
add-apt-repository ppa:nginx/stable
apt-get update
apt-get install nginx
```

Now it's a good time to update the packages:
`apt-get update && apt-get upgrade`.

Before I began to configure the webserver I've read about the common
[nginx pitfalls](http://wiki.nginx.org/Pitfalls). One thing that they've
said in this article was to distrust every article on the web about
nginx configuration. That's what you also should do regarding this post.

I've created a folder for each website and subdomain that should be
served. In my case it's one for my weblog and another one for the
reports that will be generated from the nginx logs using
[goaccess](http://goaccess.io/), but more on this later.

```bash
mkdir -p /var/www/klingt.net/html/{www,reports}
```

I've changed the ownership of the freshly created directories to
`www-data` user and group.

```bash
chown -R www-data:www-data /var/www/klingt.net
```

Nginx provides a sample configuration file that you can use as a basis
for your *server blocks* or virtual hosts, to say it in Apache terms. To
put it simply, a server block is a combination of server-name and
ip/port specification.

```bash
cp /etc/nginx/sites-available/default /etc/nginx/sites-available/klingt.net
```

Now we have a copy of the base configuration file that you can edit with
the editor of your choice. We only need the last part that begins with
`Virtual Host configuration for example.com`. It's good practice to
serve your main website from `www.domain.example` as well as
`domain.example`. It's possible to configure are redirect via [http
status code 301](http://www.wikiwand.com/en/HTTP_301) from the `www`
subdomain to the root domain or to add both urls to the `server_name`
parameter, which is what I've done. Don't forget to change the `root`
path to the directory you've created before:
`root /var/www/klingt.net/html/www;`. Now the configuration file should
look something like this:

```bash
server {
    listen 80;
    listen [::]:80; # IPv6

    server_name klingt.net www.klingt.net;

    root /var/www/klingt.net/www;
    index index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

If you haven't done it before, you should now set the `A` and `AAAA`
(IPv6) records of your domain to point to the IP address of your
droplet. When you've done that you can make a symlink from the
config-file to nginx the `sites-enabled` directory to *enable* the
server block:

```bash
ln -s /etc/nginx/sites-available/klingt.net /etc/nginx/sites-enabled/klingt.net
```

Restart nginx `service nginx restart` and your website should be served!

nginx log analytics
-------------------

At first I don't wanted to use any analytics at all, but generating a
report from the nginx logs is dead easy with
[goaccess](http://goaccess.io/) and doesn't involve injecting
third-party javascript into my website. Luckily, Ubuntu provides an
goaccess package so you can install it via `apt-get install goaccess`.
It isn't necessary to generate html reports with goaccess, because this
tool can show you the report right in the terminal, but for convenience
I want to them to be generated as an html file. My idea was pretty
straight-forward, using a cronjob that calls every 10 minutes a script
which generates a new html report using goaccess. This is the script
that calls goaccess:

```bash
#!/bin/sh

WWW_ROOT=/var/www/klingt.net/
LOG=/var/log/nginx/access.log

if [ -e $WWW_ROOT/reports ] ; then
    cat $LOG* | goaccess > $WWW_ROOT/reports/index.html
fi
```

Because the logs are rotated I have to combine them, this is done with
`cat $LOG*` which then pipes its output into goaccess. Before running
the cronjob, the date- and log-format must be specified in
/etc/goaccess.conf, in my case uncommenting the default values was
enough. Now it's time to add the cronjob, this is done with `crontab -e`
and adding this line: `*/10 * * * * /path/to/your/goaccess_reports.sh`.
Alright, now we have fresh reports every 10 minutes. Because the reports
aren't meant to be available for the whole web I've configured a [basic
HTTP
authentification](http://nginx.com/resources/admin-guide/restricting-access/).

We are almost finished, the only thing that misses is a little bit of
optimization to the nginx configuration.

### optimization

Google [PageSpeed
Insights](https://developers.google.com/speed/pagespeed/insights/)
showed me that I haven't activated gzip compression and caching.
Enabling gzip compression is easy, open your `/etc/nginx/nginx.conf` and
uncomment `gzip on;`, depending on the power of your server you could
also change the `gzip_comp_level`, but levels above 6 need much higher
processing power with minimally reduced filesize. The content-types that
should be compressed can be set under `gzip_types`.

Caching is slightly more complicated, but all I had to do was to add
this location directive to my server-block configuration
`/etc/nginx/sites-available/klingt.net`:

```bash
location ~*\.(css|js|gif|jpe?g|png|ttf|otf|woff)$ {
    expires 7d;
    add_header Cache-Control private;
}
```

I am providing a source-code link for every post on my weblog, with the
default mime.type settings you will always get an annoying download
dialog when you try to open the `.rst` source link. To fix this I had to
add a content-type `text/plain` for
[rst](http://en.wikipedia.org/wiki/ReStructuredText) files in
`/etc/nginx/mime.types`.

Don't forget to restart nginx to make the changes take effect:
`service nginx restart`.

configure ufw
-------------

One last thing is to enable the firewall. Because
[ufw](https://www.digitalocean.com/community/tutorials/how-to-setup-a-firewall-with-ufw-on-an-ubuntu-and-debian-cloud-server)
makes this super easy there is no excuse for not doing it. If you don't
want to block IPv6 you should change `IPv6` in `/etc/default/ufw` to
`no`. Ok, so lets start:

```bash
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow www
ufw enable
```

In Ubuntu `ufw enable` also creates an init.d script, so the firewall is
started automagically on boot. Enabling the firewall shows you—based on
the logs—how often someone/somewhat searches for open ports etc.,
sometimes this is a little bit scary. Maybe I will write an article
about the analysis of the firewall log.
