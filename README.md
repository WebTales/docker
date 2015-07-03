# Running Rubedo with docker
You will find here instructions to use Rubedo thanks to Docker.
### Table of Contents
**[Installation Instructions](#installation-instructions)**
* [1. Data](#1-data)
* [2. Elasticsearch](#2-elasticsearch)
* [3. Mongodb](#3-mongodb)
* [4. Apache](#4-apache)

**[Docker Compose](#docker-compose)**


## Installation Instructions
### 1. Data
This container is only here to store "data" (e.g: mongo data).
Launch this container first:

```
sudo docker run --name data -d webtales/rubedo-docker-data
```
### 2. Elasticsearch
This container will run the elasticsearch service.
Launch with:

```
sudo docker run --name elasticsearch --restart="always" -d webtales/rubedo-docker-elasticsearch:1.5
```
### 3. Mongodb
This container will run the mongodb service. Data will be store in the "Data" container.

```
sudo docker run --name mongo --volumes-from data --restart="always" -d webtales/rubedo-docker-mongodb
```
### 4. Apache
This container will run Rubedo itself. 

Thanks to the "link" property, mongodb will be accessible in this container by the hostname "mongo" and elasticsearch will be accessible by the hostname "elasticsearch"

This container can take multiple environment variables:
* URL
* GITHUB_APIKEY
* VERSION
* EXTENSIONS_REQUIRES
* EXTENSIONS_REPOSITORIES

Without any of this environment variables, this container will download the latest release : [Rubedo 3.1](https://github.com/WebTales/rubedo/releases/download/3.1.0/rubedo-3.1.tar.gz)

```
sudo docker run --name rubedo -p 80:80 --restart="always" --link elasticsearch:elasticsearch --link mongo:mongo -d webtales/rubedo-docker-apache
```

The priority variable is URL. You can set it to give the release url, for example :

```
sudo docker run --name rubedo -e URL=https://github.com/WebTales/rubedo/releases/download/3.1.0/rubedo-3.1.tar.gz -p 80:80 --restart="always" --link elasticsearch:elasticsearch --link mongo:mongo -d webtales/rubedo-docker-apache
```

If you want another version (not released) or install some extension, the GITHUB_APIKEY variable is **required**. This variable must be set with a github access token. 
This link explains how to do it and why [Creating an access token for command-line use](https://help.github.com/articles/creating-an-access-token-for-command-line-use/)

So to install rubedo with a specific version, you need to set the GITHUB_APIKEY variable and the VERSION variable. 
VERSION variable must be set with a branch version of rubedo, example 3.1.x or v3-dev:

```
sudo docker run --name rubedo -e GITHUB_APIKEY=my_access_token -e VERSION=v3-dev -p 80:80 --restart="always" --link elasticsearch:elasticsearch --link mongo:mongo -d webtales/rubedo-docker-apache
```

The last two variables are EXTENSIONS_REQUIRES and EXTENSIONS_REPOSITORIES to install rubedo extensions. 
You have to set them like in the "composer.extensions.json": 
* EXTENSIONS_REQUIRES=*name*:*branch/tag* 
* EXTENSIONS_REPOSITORIES=*type*:*url*

For example if you want to install the rubedo extension example, this is the composer.front.json:

```json
{
        "name": "rubedo/extensions",
        "require": {
            "webtales/myextension": "dev-v3-dev"
        },
        "require-dev": {},
        "repositories": [
            {
                "type": "vcs",
                "url": "git://github.com/WebTales/Extension.git"
            }
        ],
        "minimum-stability": "stable",
        "config": {
            "process-timeout": 600,
            "vendor-dir": "extensions"
        }
    }
```

Then you need to run:

```
sudo docker run --name rubedo -e GITHUB_APIKEY=my_access_token -e VERSION=v3-dev -e EXTENSIONS_REQUIRES=webtales/myextension:dev-v3-dev -e EXTENSIONS_REPOSITORIES=vcs:git://github.com/WebTales/Extension.git -p 80:80 --restart="always" --link elasticsearch:elasticsearch --link mongo:mongo -d webtales/rubedo-docker-apache
```

## Docker Compose