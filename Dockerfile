FROM php:5.6-apache

RUN apt-get update && \
    apt-get install -y nodejs \
    git \
    g++ \
    pkg-config \
    build-essential \
    libmemcached-dev \
    libmemcached-tools \
    libicu-dev \
    libmcrypt-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libfreetype6 \
    libfontconfig \
    libxml2-dev \
    vim \
    nano \
    mysql-client \
    libldap2-dev \
    wget 

RUN apt-get clean

# Extension PHP
RUN docker-php-ext-install pdo pdo_mysql
RUN docker-php-ext-install intl
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install mcrypt
RUN docker-php-ext-install zip
RUN docker-php-ext-install exif
RUN docker-php-ext-install soap
RUN docker-php-ext-install opcache
RUN docker-php-ext-install iconv
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd

# Enable PHP 56
RUN a2enmod rewrite
RUN a2enmod php5
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

COPY ./default-vhost.conf /etc/apache2/sites-available/
COPY ./lifull-produk-id.conf /etc/apache2/sites-available/

RUN a2dissite 000-default.conf
RUN a2ensite default-vhost.conf
RUN a2ensite lifull-produk-id.conf

# Composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Memcache
RUN apt-get update
RUN pecl install memcache 
RUN docker-php-ext-enable memcache

# Memcached Server
# RUN apt-get update && apt-get install -y libmemcached11 libmemcachedutil2 build-essential libmemcached-dev libz-dev
# RUN pecl install memcached-2.2.0
# RUN echo extension=memcached.so >> /usr/local/etc/php/conf.d/memcached.ini

# ALIASES
RUN echo "alias ll='ls -l'" >> /root/.bashrc
RUN echo "alias la='ls -l'" >> /root/.bashrc

ENV TERM linux
WORKDIR /var/www/my-site

COPY ./docker-entrypoint.sh /
CMD /docker-entrypoint.sh