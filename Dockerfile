FROM php:cli

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends libonig-dev xclip xsel wl-clipboard && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install mbstring

COPY ./h-m-m .

ENTRYPOINT ["./h-m-m"]
