.PHONY: clean

VERSION		:=v0.8.7
DRONE_SRC	:=drone-src-$(VERSION)
GOPATH		:=$(shell pwd)/$(DRONE_SRC)/.go

all: drone-agent drone-server

drone-agent: $(DRONE_SRC) checkout-version $(GOPATH)
	cd $(DRONE_SRC) && go get -v github.com/drone/drone/cmd/drone-agent
	cp $(GOPATH)/bin/$@ $@

drone-server: $(DRONE_SRC) checkout-version $(GOPATH)
	cd $(DRONE_SRC) && CGO_ENABLED=0 go get -v github.com/drone/drone/cmd/drone-server
	cp $(GOPATH)/bin/$@ $@

$(GOPATH): $(DRONE_SRC)
	mkdir -p $@/src/github.com/drone
	ln -sf $(shell pwd)/$(DRONE_SRC) $(GOPATH)/src/github.com/drone/drone

$(DRONE_SRC):
	git clone https://github.com/drone/drone.git $@

checkout-version: $(DRONE_SRC)
	cd $(DRONE_SRC) && git checkout --force --quiet $(VERSION)

clean:
	rm -f drone
	rm -rf drone-*
