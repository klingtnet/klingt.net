.PHONY: clean

VERSION		:=v0.10.9
CADDY_SRC	:=caddy-src
GOPATH		:=$(shell pwd)/$(CADDY_SRC)/.go

all: caddy

caddy: $(CADDY_SRC) checkout-version patch $(GOPATH)
	cd $(CADDY_SRC) && go get -v github.com/mholt/caddy/caddy
	cp $(GOPATH)/bin/$@ $@

$(GOPATH): $(CADDY_SRC)
	mkdir -p $@/src/github.com/mholt
	ln -sf $(shell pwd)/$(CADDY_SRC) $(GOPATH)/src/github.com/mholt/caddy

patch: $(CADDY_SRC)
	cd $(CADDY_SRC) && git apply ../plugins.patch

$(CADDY_SRC):
	git clone https://github.com/mholt/caddy.git $@

checkout-version: $(CADDY_SRC)
	cd $(CADDY_SRC) && git checkout --force --quiet $(VERSION)

clean:
	rm -f caddy
	rm -rf caddy-*
