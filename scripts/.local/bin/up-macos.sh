#!/bin/sh
# up-macos.sh — Report current macOS version and check for available updates
#
# Exit codes:
#   0  — macOS is up to date
#   1  — error checking for updates
#   2  — an update is available

set -u

current=$(sw_vers -productVersion)

# May take several seconds — contacts Apple's update servers
update_output=$(softwareupdate --list 2>&1)
sw_status=$?

if [ "$sw_status" -ne 0 ]; then
    printf '%s\n' "$update_output" >&2
    exit 1
fi

# softwareupdate --list output when an update exists:
#   * Label: macOS Sequoia 15.4.1-
#       Title: macOS Sequoia, Version: 15.4.1, Size: 13103100K, Recommended: YES, ...
available=$(printf '%s\n' "$update_output" \
    | grep -i 'macOS\|OS X' \
    | grep 'Version:' \
    | sed 's/.*Version: *\([0-9][0-9.]*\).*/\1/' \
    | head -1)

if [ -n "$available" ]; then
    echo "$current → $available"
    exit 2
fi

echo "$current"
exit 0
