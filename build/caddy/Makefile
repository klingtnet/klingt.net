.PHONY: clean

VERSION		:=v1.0.0
CADDY_SRC	:=caddy-src-$(VERSION)

all: caddy

caddy: $(CADDY_SRC) checkout-version patch
	cd $(CADDY_SRC) && go build -o ../$@ github.com/mholt/caddy/caddy

patch: $(CADDY_SRC)
	cd $(CADDY_SRC)\
		&& git apply ../plugins.patch\
		&& git apply ../disable-telemetry.patch

$(CADDY_SRC):
	git clone https://github.com/mholt/caddy.git $@

checkout-version: $(CADDY_SRC)
	cd $(CADDY_SRC) && git checkout --force --quiet $(VERSION)

clean:
	rm -f caddy
	rm -rf caddy-*
