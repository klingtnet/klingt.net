.PHONY: clean

VERSION:=1.13.0

all: gitea

gitea:
	@curl -o $@ -Lf 'https://github.com/go-gitea/gitea/releases/download/v$(VERSION)/gitea-$(VERSION)-linux-amd64'

clean:
	rm -f gitea
