FROM wordpress:fpm

# Installation du script docker-php-extension-installer
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Installation des extensions PHP requises
RUN install-php-extensions \
    gd \
    redis \
    opcache
# Installation de WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Configuration PHP pour de meilleures performances
RUN { \
    echo 'memory_limit = 256M'; \
    echo 'upload_max_filesize = 64M'; \
    echo 'post_max_size = 64M'; \
    echo 'max_execution_time = 300'; \
    echo 'max_input_vars = 3000'; \
    # echo 'opcache.enable=1'; \
    # echo 'opcache.memory_consumption=128'; \
    # echo 'opcache.interned_strings_buffer=8'; \
    # echo 'opcache.max_accelerated_files=4000'; \
    # echo 'opcache.revalidate_freq=2'; \
    # echo 'opcache.fast_shutdown=1'; \
} > /usr/local/etc/php/conf.d/wordpress-performance.ini
