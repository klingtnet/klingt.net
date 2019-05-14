.PHONY: grafana clean

VERSION		:=v6.2.0-beta1
GRAFANA_SRC	:=grafana-src-$(VERSION)

all: grafana
	
grafana: $(GRAFANA_SRC) checkout-version
	cd $(GRAFANA_SRC) && go run build.go build
	mkdir -p $@
	cp -r $(GRAFANA_SRC)/bin/linux-amd64 $@/bin
	cp -r $(GRAFANA_SRC)/conf $@/
	cp -r $(GRAFANA_SRC)/public $@/


$(GRAFANA_SRC):
	git clone https://github.com/grafana/grafana.git $@

checkout-version: $(GRAFANA_SRC)
	cd $(GRAFANA_SRC) && git checkout --force --quiet $(VERSION)

clean:
	rm -f "grafana*"
