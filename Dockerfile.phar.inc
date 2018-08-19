# allow creation and modification of Phar archives
RUN echo 'phar.readonly=0' > /usr/local/etc/php/conf.d/dockerstabil.ini
