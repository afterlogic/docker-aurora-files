FROM ubuntu:20.04
LABEL maintainer="AfterLogic Support <support@afterlogic.com>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
	apt-get install --no-install-recommends -y \
    wget \
	ca-certificates \
    zip \
    unzip \
    php7.4 \
    php7.4-cli \
    php7.4-common \
    php7.4-curl \
    php7.4-json \
    php7.4-mbstring \
    php7.4-mysql \
    php7.4-xml \
    apache2 \
    libapache2-mod-php7.4 \
    mariadb-common \
    mariadb-server \
    mariadb-client \
    jq &&\
	rm -rf /var/lib/apt/lists/* 

ENV LOG_STDOUT **Boolean**
ENV LOG_STDERR **Boolean**
ENV LOG_LEVEL warn
ENV ALLOW_OVERRIDE All
ENV DATE_TIMEZONE UTC

COPY run-lamp.sh /usr/sbin/
RUN chmod +x /usr/sbin/run-lamp.sh
COPY apache.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

RUN rm -rf /tmp/alwm && \
    mkdir -p /tmp/alwm && \
    wget -P /tmp/alwm https://afterlogic.org/download/aurora-files.zip && \
    unzip -q /tmp/alwm/aurora-files.zip -d /tmp/alwm/ && \
    rm /tmp/alwm/aurora-files.zip

RUN rm -rf /var/www/html && \
    mkdir -p /var/www/html && \
    cp -r /tmp/alwm/* /var/www/html && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 0777 /var/www/html/data && \
	mkdir /configs && \
	rm -rf /var/www/html/data/settings/*.bak && \
	mv /var/www/html/data/settings/* /configs
    
RUN rm -f /var/www/html/afterlogic.php
COPY afterlogic.php /var/www/html/afterlogic.php
RUN rm -rf /tmp/alwm

RUN sed -E -i -e 's/max_execution_time = 30/max_execution_time = 120/' /etc/php/7.4/apache2/php.ini \
 && sed -E -i -e 's/memory_limit = 128M/memory_limit = 512M/' //etc/php/7.4/apache2/php.ini \
 && sed -E -i -e 's/post_max_size = 8M/post_max_size = 100G/' /etc/php/7.4/apache2/php.ini \
 && sed -E -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 50G/' /etc/php/7.4/apache2/php.ini

VOLUME ["/var/www/html/data/files", "/var/www/html/data/settings", "/var/lib/mysql"]

EXPOSE 80 3306

CMD ["/usr/sbin/run-lamp.sh"]
