# Rubedo dockerfile
FROM centos:centos7
RUN yum -y update; yum -y clean all
RUN yum install -y make; yum -y clean all
# Install openssh
RUN yum -y install openssl-devel epel-release; yum -y clean all
# Install PHP env
RUN yum install -y httpd git vim php php-gd php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-snmp php-soap curl curl-devel gcc php-devel php-intl tar wget supervisor; yum -y clean all
RUN mkdir -p /var/lock/httpd /var/run/httpd /var/log/supervisor
COPY supervisord.conf /etc/supervisord.conf
# Update httpd conf
RUN cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.old && \
    rm /etc/httpd/conf.d/welcome.conf -f && \
    sed -i 's#/var/www/html#/var/www/html/rubedo/public#g' /etc/httpd/conf/httpd.conf && \
    sed -i 's#Options Indexes FollowSymLinks#Options -Indexes +FollowSymLinks#g' /etc/httpd/conf/httpd.conf && \
    sed -i 's#AllowOverride None#AllowOverride All#g' /etc/httpd/conf/httpd.conf && \
    sed -i 's#ServerName www.example.com:80#ServerName www.example.com:80\nServerName localhost:80#g' /etc/httpd/conf/httpd.conf
# Install PHP Mongo extension
RUN pecl install mongo
ADD mongo.ini /etc/php.d/mongo.ini
# Upgrade default limits for PHP
RUN sed -i 's#memory_limit = 128M#memory_limit = 512M#g' /etc/php.ini && \
    sed -i 's#max_execution_time = 30#max_execution_time = 240#g' /etc/php.ini && \
    sed -i 's#upload_max_filesize = 2M#upload_max_filesize = 20M#g' /etc/php.ini && \
    sed -i 's#;date.timezone =#date.timezone = "Europe/Paris"\n#g' /etc/php.ini
# Expose port
EXPOSE 80
ENV GITHUB_APIKEY **None**
# Start script
COPY local.php /root/local.php
COPY composer.extensions.json /root/composer.extensions.json
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /*.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
