ARG OLS_VERSION=1.8.2
ARG PHP_VERSION=lsphp83

FROM litespeedtech/openlitespeed:${OLS_VERSION}-${PHP_VERSION} as litespeed

FROM wordpress:fpm as wordpress

FROM litespeedtech/openlitespeed:${OLS_VERSION}-${PHP_VERSION}

ENV WORDPRESS_DB_HOST=mysql \
    WORDPRESS_DB_USER=wordpress \
    WORDPRESS_DB_PASSWORD=wordpress_password \
    WORDPRESS_DB_NAME=wordpress \
    WORDPRESS_TABLE_PREFIX=wp_

COPY --from=wordpress /var/www/html/ /var/www/vhosts/localhost/html/

RUN chown -R nobody:nogroup /var/www/vhosts/localhost/html/ && \
    chmod -R 755 /var/www/vhosts/localhost/html/

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/local/lsws/bin/lswsctrl", "start"]

