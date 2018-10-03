# install https://github.com/nikic/php-ast
RUN pecl install ast \
    && docker-php-ext-enable ast
