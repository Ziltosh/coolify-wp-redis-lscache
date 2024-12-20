ARG OLS_VERSION=1.8.2
ARG PHP_VERSION=lsphp82

FROM litespeedtech/openlitespeed:${OLS_VERSION}-${PHP_VERSION} as litespeed

COPY --from=litespeed /usr/local/bin/ /usr/local/bin/

RUN bash /usr/local/bin/demosite.sh
RUN bash /usr/local/bin/database.sh --domain FQDN_LITESPEED --user USER_WORDPRESS --password PASSWORD_WORDPRESS --database wordpress
RUN bash /usr/local/bin/appinstall.sh --app wordpress --domain FQDN_LITESPEED
