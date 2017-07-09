FROM ruby:2.4-slim

RUN apt-get update -qq
RUN apt-get install -qq -y --no-install-recommends \
  build-essential nodejs npm libpq-dev git fp-compiler nodejs-legacy libfontconfig1-dev cron
RUN npm install -g phantomjs

ENV APP /farma_alg_reborn

RUN mkdir -p $APP

WORKDIR $APP

ENV BUNDLE_PATH /box

COPY . $APP
