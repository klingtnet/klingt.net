.PHONY: clean

VERSION:=1.1.2

all: gitea

gitea: gitea-$(VERSION)-linux-amd64
	sha256sum $<
	cp $< $@
	chmod +x $@

gitea-$(VERSION)-linux-amd64: gitea-$(VERSION)-linux-amd64.sha256
	curl -Lsf --remote-name 'https://dl.gitea.io/gitea/$(VERSION)/gitea-$(VERSION)-linux-amd64'

gitea-$(VERSION)-linux-amd64.sha256:
	curl -Lsf --remote-name 'https://dl.gitea.io/gitea/$(VERSION)/gitea-$(VERSION)-linux-amd64.sha256'

clean:
	rm -f "gitea*"
