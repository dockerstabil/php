FROM php:7.2.8-apache-stretch


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
    && DEBIAN_FRONTEND=noninteractive apt-get -qy install build-essential git gpg libpq-dev libsqlite3-dev libxml2-dev unzip zip zlib1g-dev \
    # clean up
    && rm -rf /var/lib/apt/lists/* \
    # install extensions
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql pdo_sqlite soap zip


# composer
RUN mkdir -p /opt/composer \
    && ln -s /opt/composer/composer.phar /usr/local/bin/composer \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --install-dir=/opt/composer --filename=composer.phar \
    && php -r "unlink('composer-setup.php');"
ENV PATH="${PATH}:/root/.composer/vendor/bin"


# allow creation and modification of Phar archives
RUN echo 'phar.readonly=0' > /usr/local/etc/php/conf.d/dockerstabil.ini
