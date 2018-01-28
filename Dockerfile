#Build setup with composer
FROM composer AS build
WORKDIR /app/build
COPY . /app/build
RUN composer install --optimize-autoloader --no-interaction --no-ansi --no-dev


FROM ubuntu:16.04

ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    TERM="xterm" \
    DEBIAN_FRONTEND="noninteractive" \
    COMPOSER_ALLOW_SUPERUSER=1

EXPOSE 80
WORKDIR /app
COPY --from=build /app/build .

RUN apt-get update -q && \
    apt-get install -qy software-properties-common language-pack-en-base && \
    export LC_ALL=en_US.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    add-apt-repository -y ppa:ondrej/php && \
    apt-get update -q && \
    apt-get install --no-install-recommends -qy \
    nginx \
    unzip \
    php7.1 \
    php7.1-fpm \
    php7.1-common \
    php7.1-xml \
    php7.1-zip \
    php7.1-mysql \
    supervisor \
    mysql-client \
  && rm -rf /var/lib/apt/list/*    

COPY docker/prod/entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

RUN mkdir -p /run/php && \
    mkdir var && \

    php app/console cache:clear --no-warmup  && \
    php app/console cache:warmup && \
    
    chmod -R 777 app/logs && \
    chmod -R 777 app/cache && \
     
    cp docker/prod/php.ini /etc/php/7.1/cli/conf.d/50-settings.ini && \
    cp docker/prod/php.ini /etc/php/7.1/fpm/conf.d/50-settings.ini && \
    rm -rf /etc/php/7.1/fpm/pool.d/www.conf && \
    mv docker/prod/pool.conf /etc/php/7.1/fpm/pool.d/www.conf && \
    rm -rf /etc/nginx/nginx.conf && \
    mv docker/prod/nginx.conf /etc/nginx/nginx.conf && \
    mv docker/prod/supervisord.conf /etc/supervisor/conf.d/ && \
    
    mv docker/prod/wait-for-mysql.sh . && \
    chmod +x wait-for-mysql.sh && \

    rm -rf docker

CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
