.PHONY: clean

all: build

build: content themes
	hugo

clean:
	rm -r public

deploy: build
	rsync --update --stats -r public/* --owner --group --chown=http:http kn:/var/www/sites/klingt.net/
