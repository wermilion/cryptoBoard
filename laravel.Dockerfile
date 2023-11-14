FROM composer:latest AS vendor

WORKDIR /workdir

COPY composer.json .
COPY composer.lock .

RUN composer install \
    --ignore-platform-reqs \
    --no-interaction \
    --no-ansi \
    --no-suggest \
    --prefer-dist \
    --no-scripts \
    ; \
    echo

FROM php:8.2 as php

WORKDIR /workdir

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime; \
    echo $TZ > /etc/timezone \
RUN pecl -q channel-update pecl.php.net;
RUN apt-get update -y && apt-get install -y \
    zip \
    unzip \
    libpq-dev \
    sudo
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-install \
    pdo_pgsql \
    pgsql

COPY . .
COPY --from=vendor /workdir/vendor /workdir/vendor

ENTRYPOINT ["php", "artisan"]

RUN sudo chmod -R ugo+rw storage

CMD ["serve"]
