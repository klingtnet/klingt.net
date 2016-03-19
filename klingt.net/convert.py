#!/usr/bin/env python3

from pathlib import Path
import json
import subprocess
import os


def main():
    posts = Path('posts')
    for post in list(posts.glob('*.rst')):
        with post.open() as p:
            convert_post(p)


def convert_post(post):
    filename = post.name
    (front_matter, end) = json_front_matter(post)
# strip spaces before line ending
    content = [line.rstrip() for line in post.readlines()[end:]]
# join lines together
    content = '\n'.join(content)
# run content through pandoc
    pandoc_args = 'pandoc --from=rst --to=markdown'.split(' ')
    proc = subprocess.Popen(pandoc_args, stdin=subprocess.PIPE, stdout=subprocess.PIPE, universal_newlines=True)
    (out, err) = proc.communicate(content)
    if err is not None:
        print("Something went wrong: {}".format(err))
        return
    name, _ = os.path.splitext(filename)
    write_file(name + '.md',front_matter, out)


def write_file(fname, fm, md):
    with open(fname, 'w') as md_post:
        md_post.writelines(fm)
        md_post.write('\n\n')
        md_post.writelines(md)


def json_front_matter(post):
    fm = {} # front-matter
    valid_keys = ['title', 'description', 'tags', 'date', 'categories', 'slug']
    end = 0
    for (n, line) in enumerate(post):
        if not line.startswith('..'):
            end = n
            break
        (key, _, val) = line[2:].strip().partition(':')
        if val == "" or key not in valid_keys:
            continue
        fm[key.strip()] = val.strip()
    return (json.dumps(fm, indent=4, sort_keys=True), end)


if __name__ == '__main__':
    main()
