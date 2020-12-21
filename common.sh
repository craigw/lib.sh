#!/bin/bash

set -euo pipefail

GREEN="\033[32m"
WHITE="\033[0m"
RED="\033[31m"
YELLOW="\033[33m"
CYAN="\033[36m"
BLUE="\033[34m"
DEFAULT="\033[0m"

LOG_TAG=$(openssl rand -hex 3)
EXEC_NAME=$(basename "${0}")
EXEC_DIR=$(cd $(dirname "${0}"); pwd)

log_fatal() {
  log "FATAL" "$1" "${RED}"
}

log_error() {
  log "ERROR" "$1" "${RED}"
}

log_warn() {
  log "WARN" "$1" "${YELLOW}"
}

log_info() {
  log "INFO" "$1" "${GREEN}"
}

log_debug() {
  log "DEBUG" "$1" "${CYAN}"
}

CONST_LOG_FATAL=0
CONST_LOG_ERROR=1
CONST_LOG_WARN=2
CONST_LOG_INFO=3
CONST_LOG_DEBUG=4

# https://rubygems.org/gems/tsp
# https://rubygems.org/gems/ltb
if [[ -x "$(command -v tsp)" ]] && [[ -x "$(command -v ltb)" ]]; then
  exec 4> >(tsp | ltb)
else
  exec 4> >(echo)
fi

if [[ -z "${LOG_LEVEL-}" ]]; then
  LOG_LEVEL="INFO"
fi

log() {
  level=${1}
  eval target=\$CONST_LOG_$level
  eval current=\$CONST_LOG_$LOG_LEVEL
  if [[ "${target-0}" -le "${current-0}" ]]; then
    message=${2}
    colour=${3}
    printf "${EXEC_NAME} $$ ${LOG_TAG} ${colour}${level}${DEFAULT} ${message}\n" >&4
  fi
}
