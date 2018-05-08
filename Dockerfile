FROM ruby:2.5-alpine

RUN apk update && apk add build-base nodejs postgresql-dev yarn

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock yarn.lock package.json ./
RUN bundle install --binstubs && yarn install

COPY . .

LABEL maintainer="James Robert Rooke<james@maddington.net>"

CMD puma -C config/puma.rb