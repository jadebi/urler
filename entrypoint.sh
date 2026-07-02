#!/bin/sh
set -e

DatabasePath="${DATA_FOLDER:-$FB_DB_FOLDER}"
Permissions=$(stat -c "%a" "$DatabasePath")
UrlerId=$(id -u "urler")
OwnerId=$(stat -c "%u" "$DatabasePath")

if [ "$UrlerId" -ne "$OwnerId" ]; then
  echo "[!] Wrong owner for $DatabasePath ($OwnerId)! Fixing automatically..."
  chown -R $UrlerId:$UrlerId "$DatabasePath"
fi

if [ "$Permissions" != "770" ]; then
  echo "[!] Wrong permissions for $DatabasePath ($Permissions)! Fixing automatically..."
  chmod -R 770 "$DatabasePath"
fi

exec su-exec urler "$@"