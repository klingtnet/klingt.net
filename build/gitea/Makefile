.PHONY: clean

VERSION				:=v1.1.4
GITEA_SRC			:=gitea-src-$(VERSION)
GOPATH				:=$(shell pwd)/$(GITEA_SRC)/.go
GITEA_BUILD_TAGS	:=bindata

all: gitea

gitea: $(GITEA_SRC) checkout-version $(GOPATH)
	cd $(GOPATH)/src/code.gitea.io/gitea && TAGS=$(GITEA_BUILD_TAGS) make generate build
	cp $(GITEA_SRC)/$@ $@

$(GOPATH): $(GITEA_SRC)
	mkdir -p $@/src/code.gitea.io
	ln -sf $(shell pwd)/$(GITEA_SRC) $(GOPATH)/src/code.gitea.io/gitea

$(GITEA_SRC):
	git clone https://github.com/go-gitea/gitea.git $@

checkout-version: $(GITEA_SRC)
	cd $(GITEA_SRC) && git checkout --force --quiet $(VERSION)

clean:
	rm -f gitea
	rm -rf gitea-*
