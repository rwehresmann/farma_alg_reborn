#!/bin/bash

bundle check || bundle install

# Uncomment these lines when whant to use Whenever gem
# bundle exec whenever --update-crontab --set environment='development'
# service cron start

bundle exec bin/delayed_job start

bundle exec puma -C config/puma.rb
