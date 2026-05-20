#!/bin/sh
set -e

result=0
dir=$(dirname "$0")

run() {
  script=$1; shift
  "$script" "$@" && code=0 || code=$?
  if [ $code -ne 0 ] && [ $code -ne 2 ]; then
    echo "up-jf: $script exited with code $code" >&2
    exit $code
  fi
  if [ $code -eq 2 ]; then result=2; fi
}

run "$dir/up-1password.sh" "$@"

printf "macOS: "
run "$dir/up-macos.sh" "$@"

run "$dir/up-xcode.sh" "$@"

printf "Xcode CLT: "
run "$dir/up-xcode-clt.sh" "$@"

printf "Homebrew: "
run "$dir/up-brew.sh" "$@"

printf "Homebrew packages:\n"
run "$dir/up-brew-packages.sh" "$@"

exit $result
