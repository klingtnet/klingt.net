#!/bin/bash

CACHE=( "cache" "__pycache__" )
THEME=$1

nikola clean --clean-all
if [ -d $(THEME)/sass/.sass-cache ]; then
	echo 'removing .sass-cache'
	rm -r $(THEME)/sass/.sass-cache
fi
for c in "${CACHE[@]}"; do
	if [ -d $c ]; then
		echo 'removing nikola cache dir $(CACHE)'
		rm -r $c
	fi
done
if [ -f .doit.db ]; then
	echo 'removing doit.db'
	rm .doit.db
fi
if [ -d output ]; then
	echo 'removing output directory!'
	rm -r ./output
fi

