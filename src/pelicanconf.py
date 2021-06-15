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
