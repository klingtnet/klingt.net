.PHONY: clean

VERSION				:=v1.0.1
NODE_EXPORTER_SRC	:=node-exporter-src-$(VERSION)

all: node_exporter
	
node_exporter: $(NODE_EXPORTER_SRC) checkout-version
	cd $(NODE_EXPORTER_SRC) && go build -o ../$@ .

$(NODE_EXPORTER_SRC):
	git clone https://github.com/prometheus/node_exporter.git $@

checkout-version: $(NODE_EXPORTER_SRC)
	cd $(NODE_EXPORTER_SRC) && git checkout --force --quiet $(VERSION)

clean:
	rm -rf "node_exporter*" .go
