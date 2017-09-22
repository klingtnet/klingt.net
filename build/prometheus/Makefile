.PHONY: clean

VERSION=1.7.1

all: prometheus

prometheus: prometheus-$(VERSION).linux-amd64.tar.gz
	tar --strip-components 1 -xvf $< -- prometheus-$(VERSION).linux-amd64/$@ prometheus-$(VERSION).linux-amd64/$@.yml

prometheus-$(VERSION).linux-amd64.tar.gz:
	curl -Lsf 'https://github.com/prometheus/prometheus/releases/download/v$(VERSION)/prometheus-$(VERSION).linux-amd64.tar.gz' > $@

clean:
	rm -f prometheus "prometheus-*.tar.gz"
