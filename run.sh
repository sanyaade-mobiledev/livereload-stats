#! /bin/bash

yearly=false
if test "$1" = "-y"; then
  yearly=true
  echo "Will run yearly statistics."
  shift
fi

node bin/process.js apache-to-raw apache raw "$@"

node bin/process.js rawtodaily raw day-events "$@"
node bin/process.js reduce day-events month-events "$@"

node bin/process.js reducetemp month-events month-events-cum "$@"

node bin/process.js userinfo month-events-cum month-users "$@"

node bin/process.js usertemp month-users month-users-temp "$@"

node bin/process.js segmentation month-users-temp month-segments "$@"

node bin/report.js

if $yearly; then
  node bin/process.js reduce day-events year-events "$@"
  node bin/process.js reducetemp year-events year-events-cum "$@"
fi
