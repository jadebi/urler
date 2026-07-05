#!/bin/sh
set -e

# Overwriting with default values in case they
# were not specified in the docker-compose file
BASE_URL="${BASE_URL:-$DEFAULT_BASE_URL}"
PORT="${PORT:-$DEFAULT_PORT}"
DATA_FOLDER="${DATA_FOLDER:-$DEFAULT_DATA_FOLDER}"
LOG_FORMAT="${LOG_FORMAT:-$DEFAULT_LOG_FORMAT}"
DEBUG="${DEBUG:-$DEFAULT_DEBUG}"

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