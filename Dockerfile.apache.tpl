FROM php:{{.PHP_VERSION}}-apache-stretch


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


{{template "Dockerfile.prerequisites.inc" .}}

{{template "Dockerfile.ast.inc" .}}

{{template "Dockerfile.composer.inc" .}}
