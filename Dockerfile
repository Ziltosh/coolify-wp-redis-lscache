ARG OLS_VERSION=1.8.2
ARG PHP_VERSION=lsphp82

FROM litespeedtech/openlitespeed:${OLS_VERSION}-${PHP_VERSION}

RUN bash /bin/demosite.sh
RUN bash /bin/database.sh --domain FQDN_LITESPEED --user USER_WORDPRESS --password PASSWORD_WORDPRESS --database wordpress
RUN bash /bin/appinstall.sh --app wordpress --domain FQDN_LITESPEED
