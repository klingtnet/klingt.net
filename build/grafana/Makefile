.PHONY: grafana clean

VERSION:=5.3.2

all: grafana

grafana: grafana-$(VERSION)
	ln -sfn $< $@

grafana-$(VERSION):
	curl -Lsf 'https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-$(VERSION).linux-amd64.tar.gz' | tar -xvzf -

clean:
	rm -f "grafana*"
