.PHONY: clean

VERSION:=0.14.0
GOPATH:=$(shell pwd)/.go

all: node_exporter
	
$(GOPATH):
	mkdir -p $@

node_exporter: $(GOPATH)
	go get -v github.com/prometheus/node_exporter
	cp $(GOPATH)/bin/$@ $@

clean:
	rm -rf "node_exporter*" .go
