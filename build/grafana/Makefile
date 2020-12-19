.PHONY: grafana clean

VERSION:=7.3.5

all: grafana
	
grafana:
	@curl -Lsf 'https://dl.grafana.com/oss/release/grafana-$(VERSION).linux-amd64.tar.gz' | tar -xvzf-
	@mkdir -p $@
	@cp -r grafana-$(VERSION)/bin $@/bin
	@cp -r grafana-$(VERSION)/conf $@/
	@cp -r grafana-$(VERSION)/public $@/

clean:
	rm -rf grafana*
