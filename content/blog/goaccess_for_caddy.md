{
    "date": "2016-03-10",
    "description": "How to setup goaccess to generate stats from Caddy logs.",
    "slug": "basic-log-analysis-for-caddy-using-goaccess-and-systemd-timers",
    "tags": "caddy, systemd, goaccess, logs",
    "title": "Basic Log Analysis for Caddy Using goaccess and SystemD Timers"
}

This guide assumes that you're using journalctl to store [caddy](https://caddyserver.com/)'s log output. If you're running caddy as SystemD service and set the `log` and `errors` directive `stdout/err` then this is the case.

At first we need a log dump to analyze, `journalctl` makes it very easy to get one:

```sh
journalctl --no-pager --since -7d --priority info --ouput cat --unit caddy > /tmp/caddy.log
```

- `--output=cat` omits the log metadata (timestamp, service name etc.)
- `--no-pager` prevents journalctl from opening `less` (or whatever pager you use)
- `--since=-7d` shows the log of the last 7 days. Omit this switch to get all log entries.

Last but not least we have to filter out the noise because [goaccess](http://goaccess.io/) would otherwise refuse to parse our log output. The `--priority=info` switch will only show messages with log level `info` but don't worry, caddy logs 400 and 500 status codes to stdout.

[Installing goaccess](http://goaccess.io/download) is fairly straightforward because it's in the repos of all major linux distributions. Arch linux users can copy-paste `pacman -S goaccess`. caddy uses the [Common Log Format](https://en.wikipedia.org/wiki/Common_Log_Format) (CLF) by default, which is supported out of the box by goaccess. Now lets check if the toolchain works: `goaccess -f /tmp/caddy.log`. Remember to choose the CLF format in the next dialog.  goaccess' [documentation](http://goaccess.io/man#custom-log) is worth looking if you don't use the default log format or goaccess is complaining about your log dump.

It's time to write the goaccess config file, e.g. `~/.goaccessrc` to automatically set the log and date format. Here are the settings for caddy's CLF:

```sh
echo << EOL > ~/.goaccessrc
log-format %h %^[%d:%t %^] "%r" %s %b
date-format %d/%b/%Y
time-format %H:%M:%S
EOL
```

Web log analysis in the terminal is nice, but what we really want is an HTML report that we can view in our browser. To generate such a report run this `goaccess -p ~/.goaccessrc -f /tmp/caddy.log > /var/www/reports.mysite.com/index.html`.
Alright, now lets automate these steps by setting up a SystemD timer. You can also use a cronjob if you like.

```sh
cat << EOL > /etc/systemd/system/goaccess.timer
[Unit]
Description=Hourly generate web log report for caddy

[Timer]
OnBootSec=10min
OnUnitActiveSec=1h

[Install]
WantedBy=timers.target
EOL
```

If you want to get more into detail on how to use systemd timers then take a look in `man systemd.timers` or in the [Arch Wiki](https://wiki.archlinux.org/index.php/Systemd/Timers).
Don't forget that there has to be a corresponding service file for each timer (if not `Unit` option was set), so lets create this, too:

```sh
cat << EOL > /etc/systemd/system/goaccess.service
t]
Description=Web log report generation for caddy

[Service]
Type=oneshot
User=myuser
ExecStart=/bin/bash -c "journalctl --no-pager --output cat --priority info --unit caddy | goaccess -p ~/.goaccessrc > /var/www/reports.mysite.com/index.html"
EOL
```
Restart the systemd daemon and start and enable the timer:

```sh
systemctl daemon-reload
systemctl start --now goaccess.timer
# check if the timer was loaded
systemctl list-timers | grep goaccess
systemctl enable goaccess.timer
```

Here is, for the sake of convenience, an example caddy config for an [http basicauth](https://en.wikipedia.org/wiki/Basic_access_authentication) protected reports subdomain:

```ini
reports.mysite.com {
    root /var/www/reports.mysite.com/
    gzip
    basicauth / admin password
}
```
