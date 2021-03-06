FROM php:7.4.13-apache-buster


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
        inotify-tools \
        libldap2-dev \
        libldb-dev \
        libpng-dev \
        libpq-dev \
        libsqlite3-dev \
        libxml2-dev \
        libzip-dev \
        locales \
        unzip \
        zip \
    # clean up
    && rm -rf /var/lib/apt/lists/* \
    # generate de_DE.UTF-8 locale
    && sed -i.orig -e '/^# de_DE.UTF-8 UTF-8/ s/^# //' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    # configure extensions
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
    && docker-php-ext-configure zip \
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

COPY --from=composer:2.0.8 /usr/bin/composer /usr/bin/composer


# install https://github.com/nikic/php-ast
RUN pecl install ast \
    && docker-php-ext-enable ast


# allow creation and modification of Phar archives
RUN echo 'phar.readonly=0' > /usr/local/etc/php/conf.d/dockerstabil-phar.ini


# setup xdebug
ARG xdebug_version=2.9.6

RUN pecl install xdebug-$xdebug_version \
    && docker-php-ext-enable xdebug \
    && xdebug_ini=$(php --ini | grep xdebug | sed 's/,$//' | tail -n1) \
    && crudini --set "$xdebug_ini" XDebug xdebug.remote_enable 1 \
    && crudini --set "$xdebug_ini" XDebug xdebug.remote_autostart 1 \
    && crudini --set "$xdebug_ini" XDebug xdebug.cli_color 1 \
    && crudini --set "$xdebug_ini" XDebug xdebug.var_display_max_children 512

