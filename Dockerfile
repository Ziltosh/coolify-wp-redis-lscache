ARG OLS_VERSION=1.8.2
ARG PHP_VERSION=lsphp83
ARG WORDPRESS_DB_HOST=mysql
ARG WORDPRESS_DB_USER=wordpress
ARG WORDPRESS_DB_PASSWORD=wordpress_password
ARG WORDPRESS_DB_NAME=wordpress
ARG WORDPRESS_TABLE_PREFIX=wp_

FROM litespeedtech/openlitespeed:${OLS_VERSION}-${PHP_VERSION} as litespeed

WORKDIR /var/www/vhosts/localhost/html

RUN apt update && apt install -y git curl unzip
RUN curl -O https://wordpress.org/latest.zip
RUN unzip latest.zip
RUN rm latest.zip
RUN mv wordpress/* .
RUN rm -rf wordpress

RUN chown -R nobody:nogroup /var/www/vhosts/localhost/html/ && \
    chmod -R 755 /var/www/vhosts/localhost/html/

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]