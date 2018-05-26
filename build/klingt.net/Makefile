all: template

template: out static
	@./template.py

out:
	@mkdir -p out

static: out/assets out/favicon.ico

out/assets: out
	@cp -r assets out

out/favicon.ico: out
	@cp favicon.ico $@
