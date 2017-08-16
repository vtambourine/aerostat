#!/usr/bin/env bash

bundle check || bundle install
rm tmp/pids/*.pid
bin/rails server -b 0.0.0.0
