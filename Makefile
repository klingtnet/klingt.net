.PHONY: clean

all: build

build: content themes
	hugo

clean:
	rm -r public

deploy: build
	rsync --update --progress -r public/* --owner --group --chown=http:http kn:/var/www/sites/play.klingt.net/
