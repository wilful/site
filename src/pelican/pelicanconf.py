#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals
from os import getenv

AUTHOR = 'Андрей Семенов'
SITENAME = 'Srv-Nix'
SITESUBTITLE = 'A personal blog.'
ENV = getenv('PELICAN_ENV', 'production')
if ENV == 'testing':
    SITEURL = 'http://local.srv-nix.com'
    #PORT = 80
else:
    TINKOFF_CHAT = 'yes'
    SITEURL = 'https://srv-nix.com'
    YANDEX_METRIKA = True
    VK_SITENAME = 'Srv-Nix'
    #COMMENTO_SITENAME = 'Srv-Nix'
TIMEZONE = 'Europe/Moscow'

TAG_CLOUD_STEPS = 4
TAG_CLOUD_MAX_ITEMS = 100
TAG_CLOUD_SORTING = 'random'
TAG_CLOUD_BADGE = False

PATH = 'content'
SLUGIFY_SOURCE = 'basename'
ARTICLE_URL = '{slug}/index.html'
ARTICLE_SAVE_AS = '{slug}/index.html'
DRAFT_URL = 'drafts/{slug}/index.html'
DRAFT_SAVE_AS = 'drafts/{slug}/index.html'
PAGE_URL = 'pages/{slug}/index.html'
PAGE_SAVE_AS = 'pages/{slug}/index.html'
DRAFT_PAGE_URL = 'drafts/pages/{slug}/index.html'
DRAFT_PAGE_SAVE_AS = 'drafts/pages/{slug}/index.html'
AUTHOR_URL = 'author/{slug}/index.html'
AUTHOR_SAVE_AS = 'author/{slug}/index.html'
CATEGORY_URL = 'category/{slug}/index.html'
CATEGORY_SAVE_AS = 'category/{slug}/index.html'
TAG_URL = 'tag/{slug}/index.html'
TAG_SAVE_AS = 'tag/{slug}/index.html'

DEFAULT_LANG = 'en'
DEFAULT_METADATA = {
    'status': 'published',
    'authors': 'Andrey Semenov'
}

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None
YANDEX_ANALYTICS = True
#DISQUS_SITENAME = 'srv-nix-com'
#GITHUB_URL = 'https://github.com/wilful/srv-nix.com'
CSS_FILE = 'static/css/custom.css'
STATIC_PATHS = ['images', 'files', 'static']
EXTRA_PATH_METADATA = {
    'files/CNAME': {'path': 'CNAME'},
    'files/robots.txt': {'path': 'robots.txt'},
    'files/yandex_webmaster.template': {'path': 'yandex_668b8b3d4694a0d7.html'},
    'images/favicon.ico': {'path': 'favicon.ico'},
    'images/android-chrome-192x192.png': {'path': 'android-chrome-192x192.png'},
    'images/android-chrome-512x512.png': {'path': 'android-chrome-512x512.png'},
    'images/apple-touch-icon.png': {'path': 'apple-touch-icon.png'},
    'images/favicon-16x16.png': {'path': 'favicon-16x16.png'},
    'images/favicon-32x32.png': {'path': 'favicon-32x32.png'}
}

MENUITEMS = (('Tags', 'tags.html'),)
# Blogroll
LINKS = (('Repository', 'https://bitbucket.org/wi1fu1/'),)

# Social widget
SOCIAL = (('linkedin', 'https://www.linkedin.com/in/ansemenov/'),
         ('VK', 'https://vk.com/srvnix'),
         ('github', 'https://github.com/wilful/'),)

DEFAULT_PAGINATION = 70

THEME_TEMPLATES_OVERRIDES = ['src/pelican/templates']

#PLUGIN_PATHS = ["/where/you/cloned/it/pelican-plugins/",]
PLUGINS=["sitemap","tag_cloud"]
SITEMAP = {
    "format": "xml",
    "priorities": {
        "articles": 0.5,
        "indexes": 0.5,
        "pages": 0.5
    },
    "changefreqs": {
        "articles": "monthly",
        "indexes": "daily",
        "pages": "monthly"
    }
}

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True
