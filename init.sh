#!/usr/bin/env bash
set -e

# Overwriting with default values in case they
# were not specified in the docker-compose file
BASE_URL="${BASE_URL:-$DEFAULT_BASE_URL}"
PORT="${PORT:-$DEFAULT_PORT}"
DATA_FOLDER="${DATA_FOLDER:-$DEFAULT_DATA_FOLDER}"
LOG_FORMAT="${LOG_FORMAT:-$DEFAULT_LOG_FORMAT}"
DEBUG="${DEBUG:-$DEFAULT_DEBUG}"

# normalize LOG_FORMAT variable value to lowercase for comparison
LOG_FORMAT="$(echo "$LOG_FORMAT" | tr '[:upper:]' '[:lower:]')"

# * Simple logging function matching the Lua format
# TODO: Extend this function for complete parity between `logging.lua` and `init.sh` logging
log () {
  local level="$1"
  local message="$2"
  local timestamp
  timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

  if [[ "$LOG_FORMAT" == "json" ]]; then
    # JSON without a Context field (not needed atm.)
    printf '{"time":"%s","level":"%s","message":"(init.sh) %s"}\n' "$timestamp" "$level" "$message"
  else
    # format: [<timestamp>] [<level>] (init.sh) <message>
    printf "[%s] [%s] (init.sh) %s \n" "$timestamp" "$level" "$message"
  fi
}

UrlerId=$(id -u "urler")
Folders=(
  # "/urler/logs"
  # "/urler/tmp"
  "${DATA_FOLDER}"
)

for Folder in "${Folders[@]}"; do
  if [[ ! -d "${Folder}" ]]; then
    log "WARN" "${Folder} does not exist, creating..."
    mkdir "${Folder}" && log "INFO" "${Folder} created"
  fi
done

for Folder in "${Folders[@]}"; do
  Permissions=$(stat -c "%a" "$Folder")
  OwnerId=$(stat -c "%u" "$Folder")

  if [ "$UrlerId" -ne "$OwnerId" ]; then
    log "WARN" "Incorrect owner for ${Folder}, updating..."
    chown -R $UrlerId:$UrlerId "${Folder}" && log "INFO" "Ownership updated for ${Folder}"
  fi

  if [ "$Permissions" != "770" ]; then
    log "WARN" "Incorrect permissions for ${Folder}, updating..."
    chmod -R 770 "$Folder" && log "INFO" "Permissions updated for ${Folder}"
  fi
done

log "INFO" "Init complete, starting OpenResty"

#* Start main
# try with `su-exec`; if fails, just do `exec` (may happen when not using `urler` user)
exec "$@"
