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
    && DEBIAN_FRONTEND=noninteractive apt-get -qy install build-essential git gpg libpq-dev libsqlite3-dev unzip zip zlib1g-dev \
    # clean up
    && rm -rf /var/lib/apt/lists/* \
    # install extensions
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql pdo_sqlite zip
