# setup xdebug
ARG xdebug_version=2.5.5

RUN pecl install xdebug-$xdebug_version \
    && docker-php-ext-enable xdebug \
    && xdebug_ini=$(php --ini | grep xdebug | sed 's/,$//' | tail -n1) \
    && crudini --set "$xdebug_ini" XDebug xdebug.remote_enable 1 \
    && crudini --set "$xdebug_ini" XDebug xdebug.remote_autostart 1 \
    && crudini --set "$xdebug_ini" XDebug xdebug.cli_color 1 \
    && crudini --set "$xdebug_ini" XDebug xdebug.var_display_max_children 512
