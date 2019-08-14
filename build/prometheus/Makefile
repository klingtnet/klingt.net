.PHONY: clean

VERSION			:=v2.11.1
PROMETHEUS_SRC	:=prometheus-src-$(VERSION)

all: prometheus
	
prometheus: $(PROMETHEUS_SRC) checkout-version
	cd $(PROMETHEUS_SRC) && go build -o ../$@ github.com/prometheus/prometheus/cmd/prometheus
	cp -r $(PROMETHEUS_SRC)/documentation/examples/prometheus.yml $@.yml

$(PROMETHEUS_SRC):
	git clone https://github.com/prometheus/prometheus.git $@

checkout-version: $(PROMETHEUS_SRC)
	cd $(PROMETHEUS_SRC) && git checkout --force --quiet $(VERSION)

clean:
	rm -f "prometheus*"
	rm -rf "prometheus-src*"
