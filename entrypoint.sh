#!/bin/bash
set -e
if [ "${GITHUB_APIKEY}" != "**None**" ];
then
    git clone -b 3.1.x https://github.com/WebTales/rubedo.git /var/www/html/rubedo
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/var/www/html/rubedo
    cd /var/www/html/rubedo/
    php composer.phar config -g github-oauth.github.com "$GITHUB_APIKEY"
    ./rubedo.sh
    cd
else
    mkdir -p /var/www/html/rubedo
    wget -O /var/www/html/rubedo.tar.gz https://github.com/WebTales/rubedo/releases/download/3.1.0/rubedo-3.1.tar.gz
    tar -zxvf /var/www/html/rubedo.tar.gz -C /var/www/html/rubedo --strip-components=1
    rm -f /var/www/html/rubedo.tar.gz
fi

if [ ! -z "${USERNAME}" ] && [ ! -z "${PWDSUPERVISOR}" ]
then
    sed -i 's#username = Username#username = '"$USERNAME"'#g' /etc/supervisord.conf
    sed -i 's#password = PwdSupervisor#password = '"$PWDSUPERVISOR"'#g' /etc/supervisord.conf
fi

exec "$@"