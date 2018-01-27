#!/bin/bash
set -e

if [[ "$1" = "supervisord" ]]; then

    ./wait-for-mysql.sh

    rm -rf app/cache/*
    app/console cache:clear --env=prod --no-warmup
    app/console cache:warmup --env=prod
    chmod -R 777 app/logs
    chmod -R 777 app/cache   
fi

if [[ "$1" = "init" ]]; then

    ./wait-for-mysql.sh

    rm -rf app/cache/*
    app/console cache:clear --env=prod --no-warmup
    app/console cache:warmup --env=prod
    chmod -R 777 app/logs
    chmod -R 777 app/cache
    app/console doctrine:database:create | true
    app/console doctrine:schema:update -f | true
    app/console doctrine:fixture:load --append | true
fi

exec "$@"
