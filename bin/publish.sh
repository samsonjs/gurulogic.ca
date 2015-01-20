#!/bin/bash

# exit on errors
set -e

bail() {
    echo fail: $*
    exit 1
}

PUBLISH_HOST="gurulogic.ca"
PUBLISH_DIR="gurulogic.ca/public"
ECHO=0
RSYNC_OPTS=""

BREAK_WHILE=0
while [[ $# > 0 ]]; do
  ARG="$1"
  case "$ARG" in

    -t|--test)
      ECHO=1
      RSYNC_OPTS="$RSYNC_OPTS --dry-run"
      shift
      ;;

    -d|--delete)
      RSYNC_OPTS="$RSYNC_OPTS --delete"
      shift
      ;;

    # we're at the paths, no more options
    *)
      BREAK_WHILE=1
      break
      ;;

  esac

  [[ $BREAK_WHILE -eq 1 ]] && break
done

if [[ $# -eq 0 ]]; then
  CMD="rsync -aKv $RSYNC_OPTS public/ $PUBLISH_HOST:$PUBLISH_DIR"
else
  CMD="rsync -aKv $RSYNC_OPTS $@ $PUBLISH_HOST:$PUBLISH_DIR"
fi

if [[ $ECHO -eq 1 ]]; then
  echo "$CMD"
fi

$CMD
