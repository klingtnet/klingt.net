all: out out/assets out/favicon.ico
	@./template.py

out:
	@mkdir -p out

out/assets: out
	@cp -r assets out

out/favicon.ico: out
	@cp favicon.ico $@
