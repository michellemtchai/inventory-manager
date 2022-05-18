#! /bin/sh

set -e
echo "== Start bundle install..."
bundle config set no-cache 'true'
bundle config set no-prune 'true'
bundle install
echo "== End bundle install"

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

echo "== Remove pre-existing server.pid"
rm -f ./tmp/pids/server.pid

echo "== Starting API server"
exec rails s -b '0.0.0.0'
