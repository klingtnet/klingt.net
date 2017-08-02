.PHONY: clean

VERSION:=1.1.2
PLUGINS:=http.cgi,http.cors,http.filemanager,http.filter,http.ipfilter,http.mailout,http.minify,http.prometheus,http.ratelimit,http.realip,http.restic,http.upload,http.cache

all: caddy

caddy:
	curl -Lsf 'https://caddyserver.com/download/linux/amd64?plugins=$(PLUGINS)' | tar -xzf - -- $@

clean:
	rm -f caddy
