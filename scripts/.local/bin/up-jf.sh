#!/bin/sh
set -e

result=0

run() {
  script=$1; shift
  "$script" "$@" && code=0 || code=$?
  if [ $code -ne 0 ] && [ $code -ne 2 ]; then
    echo "up-jf: $script exited with code $code" >&2
    exit $code
  fi
  [ $code -eq 2 ] && result=2
}

printf "MAC OS: "
run ./up-macos.sh "$@"

printf "Xcode Command Line Tools: "
run ./up-xcode-clt.sh "$@"

printf "Homebrew: "
run ./up-brew.sh "$@"

exit $result
