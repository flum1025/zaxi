FROM ruby:2.5-alpine3.7

ADD ./ /app
WORKDIR /app

RUN apk add --no-cache --virtual .ruby-builddeps build-base && \
  apk add --no-cache openssl && \
  gem install bundler --no-document && \
  bundle install --without development && \
  apk del --purge .ruby-builddeps

ENTRYPOINT ruby main.rb
