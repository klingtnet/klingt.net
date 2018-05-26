#!/usr/bin/env python3

import os

def read_template():
    with open('template.html') as f:
        return f.read()


def title_from_filename(fname: str) -> str:
    return os.path.splitext(fname)[0].replace('-', ' ')


def template_pages(pages: dict, template: str, dest_path: str):
    nav_item = '<li><a href="{item_href}" class="nav-item">{item_text}</a></li>'
    
    for page, text in pages.items():
        title = title_from_filename(page)
        other_pages = [ p for p in pages.keys() if p != page ]
        nav = ''.join([ nav_item.format(item_href=p, item_text=title_from_filename(p)) for p in other_pages ])
        templated_page = template.format(title=title, nav=nav, content=text)
        
        with open(os.path.join(dest_path, page), 'w') as f:
            f.write(templated_page)


pages = dict()
for page in os.listdir('pages'):
    with open(os.path.join('pages', page)) as f:
        pages[page] = f.read()

template_pages(pages, read_template(), 'out')