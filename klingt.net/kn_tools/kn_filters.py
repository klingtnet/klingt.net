from os.path import join as pathjoin, exists, dirname
from os import getcwd
from subprocess import call
from sys import stderr
from nikola.filters import runinplace

# js and css compressor from https://github.com/yui/yuicompressor/releases
def yui_compressor(infile):
    yui_c = pathjoin(dirname(__file__), '_3rdparty', 'yuicompressor-2.4.8.jar')
    if exists(yui_c):
        if not 'assets/libs' in infile:
            print('>>> Minifying {}'.format(infile), file=stderr)
            return runinplace(r'java -jar {} %1 -o %2'.format(yui_c), infile)
        else:
            return None
    else:
        print('yuicompressor not found!', file=stderr)
