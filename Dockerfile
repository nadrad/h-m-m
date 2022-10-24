FROM php:cli

WORKDIR /app

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  libonig-dev xclip xsel wl-clipboard

RUN docker-php-ext-install mbstring

COPY ./h-m-m .

CMD ["./h-m-m"]
