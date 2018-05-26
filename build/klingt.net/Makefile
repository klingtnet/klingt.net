all: template

template: out static $(wildcard pages/*.html) template.html
	@./template.py

serve: template
	@cd out && python3 -m http.server

out:
	@mkdir -p out

static: out/assets out/favicon.ico

out/assets: assets
	@cp -r assets out

out/favicon.ico: out favicon.ico
	@cp favicon.ico $@
