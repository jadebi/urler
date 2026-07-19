#!/usr/bin/env bash
set -e

# Overwriting with default values in case they
# were not specified in the docker-compose file
BASE_URL="${BASE_URL:-$DEFAULT_BASE_URL}"
PORT="${PORT:-$DEFAULT_PORT}"
DATA_FOLDER="${DATA_FOLDER:-$DEFAULT_DATA_FOLDER}"
LOG_FORMAT="${LOG_FORMAT:-$DEFAULT_LOG_FORMAT}"
DEBUG="${DEBUG:-$DEFAULT_DEBUG}"

UrlerId=$(id -u "urler")
Folders=(
  "/urler/logs"
  "/urler/tmp"
  "${DATA_FOLDER}"
)

for Folder in "${Folders[@]}"; do
  if [[ ! -d "${Folder}" ]]; then
    echo "Creating ${Folder}"
    mkdir "${Folder}"
  else
    echo "${Folder} exists"
  fi
done

for Folder in "${Folders[@]}"; do
  Permissions=$(stat -c "%a" "$Folder")
  OwnerId=$(stat -c "%u" "$Folder")

  if [ "$UrlerId" -ne "$OwnerId" ]; then
    echo "Fixing owner for $Folder"
    chown -R $UrlerId:$UrlerId "$Folder"
  fi

  if [ "$Permissions" != "770" ]; then
    echo "Fixing permissions for $Folder"
    chmod -R 770 "$Folder"
  fi
done

echo "Starting main (permissions are ok)"

# Start main
exec su-exec urler "$@"
