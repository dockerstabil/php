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

COPY --from=composer:{{.COMPOSER_VERSION}} /usr/bin/composer /usr/bin/composer
