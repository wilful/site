#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = 'Andrey Semenov'
SITENAME = 'Srv-Nix'
SITESUBTITLE = 'A personal blog.'
SITEURL = 'https://srv-nix.com'
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
VK_SITENAME = 'Srv-Nix'
GITHUB_URL = 'https://github.com/wilful/srv-nix.com'
STATIC_PATHS = ['images']
EXTRA_PATH_METADATA = {
    'images/robots.txt': {'path': 'robots.txt'},
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

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True
