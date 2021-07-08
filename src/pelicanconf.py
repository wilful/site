#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals
from os import getenv

AUTHOR = 'Andrey Semenov'
SITENAME = 'Srv-Nix'
SITESUBTITLE = 'A personal blog.'
ENV = getenv('PELICAN_ENV', 'production')
if ENV == 'testing':
    SITEURL = 'http://localhost:8000'
else:
    SITEURL = 'https://srv-nix.com'
    YANDEX_METRIKA = True
    VK_SITENAME = 'Srv-Nix'
TIMEZONE = 'Europe/Moscow'

PATH = 'content'

DEFAULT_LANG = 'en'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None
YANDEX_ANALYTICS = True
#DISQUS_SITENAME = 'srv-nix-com'
GITHUB_URL = 'https://github.com/wilful/srv-nix.com'
STATIC_PATHS = ['images', 'files']
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

# Blogroll
LINKS = (('Repository', 'https://bitbucket.org/wi1fu1/'),)

# Social widget
SOCIAL = (('linkedin', 'https://www.linkedin.com/in/ansemenov/'),
          ('VK', 'https://vk.com/srvnix'),
          ('github', 'https://github.com/wilful/'),)

DEFAULT_PAGINATION = 70

THEME_TEMPLATES_OVERRIDES = ['src/templates']

#PLUGIN_PATHS = ["/where/you/cloned/it/pelican-plugins/",]
PLUGINS=["sitemap",]
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
