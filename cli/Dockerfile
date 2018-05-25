FROM php:7.0.30-cli-stretch


# workdir
RUN mkdir -p /app
WORKDIR /app


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
    && DEBIAN_FRONTEND=noninteractive apt-get -qy install build-essential git gpg unzip zip zlib1g-dev \
    # clean up
    && rm -rf /var/lib/apt/lists/* \
    # install zip extension
    && docker-php-ext-install zip


# composer
RUN mkdir -p /opt/composer-1.6.4 \
    && ln -s /opt/composer-1.6.4/composer.phar /usr/local/bin/composer \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --version=1.6.4 --install-dir=/opt/composer-1.6.4 --filename=composer.phar \
    && php -r "unlink('composer-setup.php');"
ENV PATH="${PATH}:/root/.composer/vendor/bin"

