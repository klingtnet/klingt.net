.PHONY: clean

VERSION		:=v0.10.8
CADDY_SRC	:=caddy-src-$(VERSION)
GOPATH		:=$(shell pwd)/$(CADDY_SRC)/.go

all: caddy

caddy: $(CADDY_SRC) checkout-version patch $(GOPATH)
	cd $(CADDY_SRC) && go get -v github.com/mholt/caddy/caddy
	cp $(GOPATH)/bin/$@ $@

$(GOPATH): $(CADDY_SRC)
	mkdir -p $@/src/github.com/mholt
	ln -sf $(shell pwd)/$(CADDY_SRC) $(GOPATH)/src/github.com/mholt/caddy

patch: $(CADDY_SRC)
	cd $(CADDY_SRC)\
		&& git apply ../plugins.patch\
		&& git revert --no-edit --no-commit 56453e9664aa2c24115eb52a4e933febb3cac1f7

$(CADDY_SRC):
	git clone https://github.com/mholt/caddy.git $@

checkout-version: $(CADDY_SRC)
	cd $(CADDY_SRC) && git checkout --force --quiet $(VERSION)

clean:
	rm -f caddy
	rm -rf caddy-*
