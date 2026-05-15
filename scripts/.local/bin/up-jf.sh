#!/bin/sh
set -e

UPDATE=""
case "$1" in
  --update|-u) UPDATE="--update" ;;
esac

run() {
  "$1" $UPDATE
  code=$?
  if [ $code -ne 0 ] && [ $code -ne 2 ]; then
    echo "up-jf: $1 exited with code $code" >&2
    exit $code
  fi
}

printf "MAC OS: "
run ./up-macos.sh
