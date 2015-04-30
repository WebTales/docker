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

mv /root/local.php /var/www/html/rubedo/config/autoload/local.php
chmod 777 /var/www/html/rubedo/config/autoload/local.php

sed -i 's#"fromEmailNotification" => ""#"fromEmailNotification" => "'"$EMAIL"'"#g' /var/www/html/rubedo/config/autoload/local.php

#/usr/bin/supervisord -c /etc/supervisord.conf
/usr/sbin/httpd
curl 'http://localhost/install/index/define-languages' -H 'Pragma: no-cache' -H 'Origin: http://localhost' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: fr-FR,fr;q=0.8,en-US;q=0.6,en;q=0.4' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: no-cache' -H 'Referer: http://localhost/install/index/define-languages' -H 'Cookie: zdt-hidden=0' -H 'Connection: keep-alive' -H 'X-FirePHP-Version: 0.0.6' --data 'defaultLanguage=en&buttonGroup%5BSubmit%5D=Submit' --compressed
curl 'http://localhost/install/index/set-db-contents?doInsertGroups=1' -H 'Pragma: no-cache' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: fr-FR,fr;q=0.8,en-US;q=0.6,en;q=0.4' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Referer: http://localhost/install/index/set-db-contents' -H 'Cookie: zdt-hidden=0' -H 'Connection: keep-alive' -H 'X-FirePHP-Version: 0.0.6' -H 'Cache-Control: no-cache' --compressed
curl 'http://localhost/install/index/set-db-contents?doEnsureIndex=1' -H 'Pragma: no-cache' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: fr-FR,fr;q=0.8,en-US;q=0.6,en;q=0.4' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Referer: http://localhost/install/index/set-db-contents?doInsertGroups=1' -H 'Cookie: zdt-hidden=0' -H 'Connection: keep-alive' -H 'X-FirePHP-Version: 0.0.6' -H 'Cache-Control: no-cache' --compressed
curl 'http://localhost/install/index/set-db-contents?initContents=1' -H 'Pragma: no-cache' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: fr-FR,fr;q=0.8,en-US;q=0.6,en;q=0.4' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Referer: http://localhost/install/index/set-db-contents?doEnsureIndex=1' -H 'Cookie: zdt-hidden=0' -H 'Connection: keep-alive' -H 'X-FirePHP-Version: 0.0.6' -H 'Cache-Control: no-cache' --compressed
curl 'http://localhost/install/index/set-admin' -H 'Pragma: no-cache' -H 'Origin: http://localhost' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: fr-FR,fr;q=0.8,en-US;q=0.6,en;q=0.4' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: no-cache' -H 'Referer: http://localhost/install/index/set-admin' -H 'Cookie: zdt-hidden=0' -H 'Connection: keep-alive' -H 'X-FirePHP-Version: 0.0.6' --data 'name=admin&login=admin&password=admin&confirmPassword=admin&email='"$EMAIL"'&buttonGroup%5BSubmit%5D=Submit' --compressed

exec "$@"