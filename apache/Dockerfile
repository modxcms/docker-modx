FROM php:8.3.2-apache

ENV MODX_VERSION 3.0.4
ENV MODX_SHA1 d8a4eb22e60b4cef0ae85d26e8a5ac3669214251

RUN a2enmod rewrite

# install the PHP extensions we need
RUN apt-get update -y \
    && apt-get install -y \
          libpng-dev \
          libjpeg-dev \
          libzip-dev \
          zip \
          unzip \
          sudo

RUN docker-php-ext-configure \
      gd --with-jpeg=/usr

RUN docker-php-ext-install \
      bcmath \
      gd \
      opcache \
      mysqli \
      pdo \
      pdo_mysql \
      zip

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# set timezone
RUN { \
		echo 'date.timezone=GMT+0'; \
	} > /usr/local/etc/php/conf.d/datetime.ini

# upstream tarballs include ./modx-${MODX_VERSION}/
RUN cd /usr/local/src \
    && curl -o modx.zip -SL http://modx.com/download/direct/modx-${MODX_VERSION}-pl.zip \
    && echo "$MODX_SHA1 *modx.zip" | sha1sum -c - \
    && unzip -qq modx.zip -d ./ \
    && mv "/usr/local/src/modx-${MODX_VERSION}-pl"/** /var/www/html/ \
    && find /var/www/html -name 'ht.access' -exec bash -c 'mv $0 ${0/ht.access/.htaccess}' {} \; \
    && rm -rf /usr/local/src/modx-${MODX_VERSION}-pl /usr/local/src/modx.zip

RUN chown -R www-data:www-data /var/www/html

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

VOLUME /var/www/html
