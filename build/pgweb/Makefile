.PHONY: clean

VERSION:=0.9.7

all: pgweb

pgweb: pgweb_linux_amd64
	cp $< $@
	chmod +x $@

pgweb_linux_amd64:
	curl -Lsf 'https://github.com/sosedoff/pgweb/releases/download/v$(VERSION)/pgweb_linux_amd64.zip' | bsdtar -xvzf -

clean:
	rm -f pgweb
