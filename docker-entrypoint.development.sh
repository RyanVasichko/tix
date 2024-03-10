#!/bin/bash
set -e

bundle check || bundle install -j 4
rm -f /dosey_doe_tickets/tmp/pids/server.pid
exec "$@"
