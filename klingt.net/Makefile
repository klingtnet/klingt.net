all: build

rebuild: clean theme build

BUILD_OPTS="-n 3"
THEME=themes/klingt-net

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

deploy:
	nikola deploy
