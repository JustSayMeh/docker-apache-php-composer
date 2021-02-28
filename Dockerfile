FROM ubuntu:16.04


ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
RUN apt-get update
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:ondrej/php -y
RUN apt-get update && \
	apt-get install -y apache2 \
	libapache2-mod-php7.4 \
	php7.4-mysql \
	php7.4-gd \
	php-pear \
	php-apcu \
	php7.4-mcrypt \
	php7.4-json \
	php7.4-curl \
	curl lynx-cur \
	&& rm -rf /var/lib/apt/lists/* \
	&& apt-get clean -y


RUN cd /tmp && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer


RUN a2enmod php7.4
RUN a2enmod rewrite


RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.4/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/7.4/apache2/php.ini


ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80

ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf


CMD /usr/sbin/apache2ctl -D FOREGROUND


EXPOSE 80