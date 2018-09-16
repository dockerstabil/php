# setup xdebug
ARG xdebug_version=2.5.5

RUN pecl install xdebug-$xdebug_version \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.remote_enable=1\n\
xdebug.remote_autostart=1\n\
" > /usr/local/etc/php/conf.d/dockerstabil-xdebug.ini
