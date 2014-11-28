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
	./clean.sh $(THEME)

deploy:
	nikola deploy
