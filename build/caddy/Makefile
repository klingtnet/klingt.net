.PHONY: clean

VERSION		:=v1.0.5
CADDY_SRC	:=caddy-src-$(VERSION)

all: caddy

caddy: $(CADDY_SRC) checkout-version patch
	cd $(CADDY_SRC) && GO111MODULE=on go build -o ../$@ github.com/caddyserver/caddy/caddy

patch: $(CADDY_SRC)
	cd $(CADDY_SRC)\
		&& git apply ../plugins.patch\
		&& git apply ../disable-telemetry.patch

$(CADDY_SRC):
	git clone https://github.com/caddyserver/caddy.git $@

checkout-version: $(CADDY_SRC)
	cd $(CADDY_SRC) && git checkout --force --quiet $(VERSION)

clean:
	rm -f caddy
	rm -rf caddy-*
