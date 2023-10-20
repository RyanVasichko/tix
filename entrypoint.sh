#!/bin/bash
set -e

# install missing gems
bundle check || bundle install --jobs 20 --retry 5

bin/rails db:prepare

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"