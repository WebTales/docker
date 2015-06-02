# Rubedo dockerfile
FROM centos:centos7
RUN yum -y update; yum -y clean all
RUN yum install -y make openssl-devel epel-release; yum -y clean all
# Install PHP env
RUN yum install -y httpd git vim php php-gd php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-snmp php-soap curl curl-devel gcc php-devel php-intl tar wget; yum -y clean all
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
ENV URL **None**
ENV VERSION **None**
ENV GITHUB_APIKEY **None**
ENV EXTENSIONS_REQUIRES **None**
ENV EXTENSIONS_REPOSITORIES **None**
RUN mkdir -p /root/.ssh && \
    echo "github.com,192.30.252.131 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==" > /root/.ssh/known_hosts && \
    chmod 644 /root/.ssh/known_hosts
# Start script
COPY generate-composer-extension.py /generate-composer-extension.py
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /*.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/tail", "-f", "/var/log/httpd/error_log"]
