#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# If you're using a Free instance type, you need to
# perform database migrations in the build command.
# Uncomment the following line:

if rake db:exists; then
  echo
  echo "== Database exists. Running db:migrate."
  echo
  rake db:migrate
else
  echo
  echo "== Database doesn't exist. Running db:reset."
  echo
  rake db:create db:migrate db:seed
fi
