.PHONY: clean

all: build

build: content themes
	hugo

clean:
	rm -r public

deploy: build
	rsync --update --stats -r public/* --owner --group --chown=www-data:www-data kn:/var/www/sites/klingt.net/
