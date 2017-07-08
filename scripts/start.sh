
#!/bin/bash

bundle check || bundle install

bundle exec bin/delayed_job start

bundle exec puma -C config/puma.rb
