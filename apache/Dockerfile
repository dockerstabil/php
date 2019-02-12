FROM php:7.3.2-apache-stretch


# workdir
RUN mkdir -p /app
WORKDIR /app


# apache config
ENV APACHE_DOCUMENT_ROOT="/app/public"
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf \
    # enable .htaccess
    && sed -i 's/\(AllowOverride\s\)None/\1All/' $APACHE_CONFDIR/apache2.conf \
    # enable apache modules
    && a2enmod \
        auth_basic\
        auth_digest\
        authn_dbm\
        authn_file\
        authz_groupfile\
        headers\
        proxy_http\
        proxy\
        rewrite\
        ssl


#
# prerequisites
#
# Notes:
# * [apt-get best practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#run)
# * [DEBIAN_FRONTEND=noninteractive](https://docs.docker.com/engine/faq/#why-is-debian_frontendnoninteractive-discouraged-in-dockerfiles)
#
RUN DEBIAN_FRONTEND=noninteractive apt-get -qy update \
    # preliminaries
    && DEBIAN_FRONTEND=noninteractive apt-get -qy install apt-utils \
    && DEBIAN_FRONTEND=noninteractive apt-get -qy install \
        build-essential \
        cracklib-runtime \
        crudini \
        git \
        gpg \
        libldap2-dev \
        libldb-dev \
        libpng-dev \
        libpq-dev \
        libsqlite3-dev \
        libxml2-dev \
        libzip-dev \
        unzip \
        zip \
    # clean up
    && rm -rf /var/lib/apt/lists/* \
    # configure extensions
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
    && docker-php-ext-configure zip --with-libzip \
    # install extensions
    && docker-php-ext-install \
        bcmath \
        gd \
        ldap \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pdo_sqlite \
        pgsql \
        soap \
        zip


# install https://github.com/nikic/php-ast
RUN pecl install ast \
    && docker-php-ext-enable ast


# composer
RUN mkdir -p /opt/composer \
    && ln -s /opt/composer/composer.phar /usr/local/bin/composer \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --install-dir=/opt/composer --filename=composer.phar \
    && php -r "unlink('composer-setup.php');"
ENV PATH="${PATH}:/root/.composer/vendor/bin"

