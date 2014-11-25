all: build

rebuild: clean theme build

BUILD_OPTS="-n 3"
THEME=themes/klingt-net
CACHE=cache

build:
	nikola build $(BUILD_OPTS)

theme:
	@echo "Building theme $(THEME) ..."
	@$(THEME)/build.sh

clean:
	nikola clean
	@if [ -d $(THEME)/sass/.sass-cache ]; then\
		echo 'removing .sass-cache';\
		rm -r $(THEME)/sass/.sass-cache;\
	fi
	@if [ -d $(CACHE) ]; then\
		echo 'removing nikola cache dir $(CACHE)';\
		rm -r $(CACHE);\
	fi
	@if [ -f .doit.db ]; then\
		echo 'removing doit.db';\
		rm .doit.db;\
	fi

deploy:
	nikola deploy
