FROM ruby:2.4-alpine

RUN apk update && apk add build-base postgresql-dev imagemagick file \
  && echo https://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories \
  && echo https://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories \
  && apk add --update nodejs nodejs-npm yarn

RUN mkdir /frishtug
ENV $APP_HOME /frishtug
COPY Gemfile* yarn.lock package.json $APP_HOME
WORKDIR $APP_HOME
RUN bundle install --binstubs && yarn install

COPY . .

LABEL maintainer="James Robert Rooke<james@maddington.net>"

CMD puma -C config/puma.rb