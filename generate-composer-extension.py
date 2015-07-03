#!/usr/bin/env python
import json
import os

EXTENSIONS_REQUIRES = os.getenv("EXTENSIONS_REQUIRES", "")
EXTENSIONS_REPOSITORIES = os.getenv("EXTENSIONS_REPOSITORIES", "")

def generate_requires():
    res = {"webtales/Client": "dev-master"}
    if EXTENSIONS_REQUIRES:
        for require in EXTENSIONS_REQUIRES.split(','):
            req = require.split(':')
            res[req[0].strip()] = req[1].strip()
    return res

def generate_repositories():
    repos = [
        {
            "url": "https://github.com/WebTales/rubedo-client.git",
            "type": "vcs"
        }
    ]
    if EXTENSIONS_REPOSITORIES:
        for repo in EXTENSIONS_REPOSITORIES.split(','):
            req = repo.split(':', 1)
            rep = {'type': req[0].strip(), 'url': req[1].strip()}
            repos.append(rep)
    return repos

require = generate_requires()
repositories = generate_repositories()
composerExtension = {'name': 'rubedo/extensions', 'require': require, 'require-dev': {}, 'repositories': repositories,
                     'minimum-stability': 'dev', 'config': {'process-timeout': 600, 'vendor-dir': 'extensions'}}
print json.dumps(composerExtension, sort_keys=False, indent=4, separators=(',', ': '))
