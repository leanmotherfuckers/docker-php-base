FROM php:7.3-apache
ENV PHP_VERSION=7.3
WORKDIR /var/www/html
RUN apt-get update -y && apt-get install -y libzip-dev libxml2-dev libwebp-dev \
    libjpeg62-turbo-dev libpng-dev libxpm-dev libfreetype6-dev libbz2-dev \
    libjpeg-dev libmcrypt-dev git curl
RUN apt-get update && \
    apt-get install -y \
        zlib1g-dev
RUN docker-php-ext-install mysqli mbstring zip soap pdo pdo_mysql
RUN docker-php-ext-configure gd --with-gd --with-webp-dir --with-jpeg-dir \
    --with-png-dir --with-zlib-dir --with-xpm-dir --with-freetype-dir
RUN docker-php-ext-install gd
RUN apt-get install -y libgmp-dev re2c libmhash-dev libmcrypt-dev file
RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/local/include/ || true
RUN docker-php-ext-configure gmp
RUN docker-php-ext-install gmp
RUN docker-php-ext-install exif
ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/
RUN chmod uga+x /usr/local/bin/install-php-extensions && sync && install-php-extensions imagick
RUN a2enmod rewrite
COPY ./config/php /usr/local/etc/php/conf.d
COPY ./config/apache /etc/apache2/conf-enabled
