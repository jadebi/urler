#!/usr/bin/env bash

# * Get hostname from BASE_URL (needed for nginx config)
# "${var#pattern}" removes the shortest prefix matching "pattern"
# this strips the protocol prefix (e.g. http:// or https://)
# e.g. "https://google.com/path" -> "google.com/path" ("${BASE_URL#http*://}" matched "https://")
SERVER_NAME="${BASE_URL#http*://}"
# "${var%%pattern}" removes the longest suffix matching "pattern"
# This strips everything from the first "/" onwards
# e.g. "google.com/path" -> "google.com" ("${SERVER_NAME%%/*}" matched "/path")
export SERVER_NAME="${SERVER_NAME%%/*}"
# in the end e.g. "https://google.com/path/" turns to "google.com" (i hope...)

envsubst '${SERVER_NAME} ${PORT}' < /urler/nginx.conf.template > /usr/local/openresty/nginx/conf/nginx.conf
