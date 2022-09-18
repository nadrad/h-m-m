FROM php:cli

WORKDIR /app

COPY ./h-m-m .

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  libonig-dev xclip xsel wl-clipboard

RUN docker-php-ext-install mbstring

RUN chmod +x h-m-m

CMD ["./h-m-m"]
