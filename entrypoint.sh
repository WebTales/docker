#!/bin/bash
set -e
if [ -d /var/www/html/rubedo/ ]; then
    rm -rf /var/www/html/rubedo
fi
if [ ! -z "${MONGO_PORT_27017_TCP_ADDR}" ] && [ ! -z "${MONGO_PORT_27017_TCP_PORT}" ]
then
    while ! exec 6<>/dev/tcp/${MONGO_PORT_27017_TCP_ADDR}/${MONGO_PORT_27017_TCP_PORT}; do
        echo "$(date) - still trying to connect to ${MONGO_PORT_27017_TCP_ADDR}/${MONGO_PORT_27017_TCP_PORT}"
        sleep 1
    done
    exec 6>&-
    exec 6<&-
fi

if [ -d /var/rubedo_sources ] && [ "${GITHUB_APIKEY}" = "**None**" ]; then
    echo "coping Rubedo"
    cp -R /var/rubedo_sources /var/www/html/rubedo
    /usr/sbin/httpd -k start
else
    if [ "${EXTENSIONS_REQUIRES}" = "**None**" ]; then
        unset EXTENSIONS_REQUIRES
    fi

    if [ "${EXTENSIONS_REPOSITORIES}" = "**None**" ]; then
        unset EXTENSIONS_REPOSITORIES
    fi

    if [ "${EMAIL}" = "**None**" ]; then
        unset EMAIL
    fi

    if [ "${LOGIN}" = "**None**" ]; then
        unset LOGIN
    fi

    if [ "${SALT}" = "**None**" ]; then
        unset SALT
    fi

    if [ "${PASSWORD}" = "**None**" ]; then
        unset PASSWORD
    fi

    if [ "${VERSION}" != "**None**" ]; then
        git clone -b "$VERSION" https://github.com/WebTales/rubedo.git /var/www/html/rubedo
    else
        git clone -b 3.1.x https://github.com/WebTales/rubedo.git /var/www/html/rubedo
    fi
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/var/www/html/rubedo
    python generate-composer-extension.py >> /var/www/html/rubedo/composer.extensions.json
    cd /var/www/html/rubedo/
    php composer.phar config -g github-oauth.github.com "$GITHUB_APIKEY"
    ./rubedo.sh

    chmod -R 777 /var/www/html/rubedo/cache/
    chmod -R 777 /var/www/html/rubedo/public/captcha
    chmod -R 777 /var/www/html/rubedo/public/generate-image
    chmod -R 777 /var/www/html/rubedo/public/theme
    mv /root/local.php /var/www/html/rubedo/config/autoload/local.php
    chmod  777 /var/www/html/rubedo/config/autoload/local.php

    sed -i 's#"fromEmailNotification" => ""#"fromEmailNotification" => "'"$EMAIL"'"#g' /var/www/html/rubedo/config/autoload/local.php

    /usr/sbin/httpd -k start
    curl http://localhost/install/index/init
fi


exec "$@"
