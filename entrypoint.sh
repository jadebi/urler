#!/bin/sh
set -e

# Overwriting with fallback-values in case they
# were not specified in the docker-compose file
BASE_URL="${BASE_URL:-$FB_BASE_URL}"
DATA_FOLDER="${DATA_FOLDER:-$FB_DATA_FOLDER}"
LOG_FORMAT="${LOG_FORMAT:-$FB_LOG_FORMAT}"

Permissions=$(stat -c "%a" "$DATA_FOLDER")
UrlerId=$(id -u "urler")
OwnerId=$(stat -c "%u" "$DATA_FOLDER")

if [ "$UrlerId" -ne "$OwnerId" ]; then
  echo "Fixing owner for $DATA_FOLDER (was $OwnerId)"
  chown -R $UrlerId:$UrlerId "$DATA_FOLDER"
fi

if [ "$Permissions" != "770" ]; then
  echo "Fixing permissions for $DATA_FOLDER (was $Permissions)"
  chmod -R 770 "$DATA_FOLDER"
fi

echo "Starting main (permissions are ok)"

# Start main
exec su-exec urler "$@"