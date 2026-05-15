#!/usr/bin/env bash
# up-xcode-clt.sh
# Checks whether Xcode Command Line Tools is installed and up-to-date.
# Exit codes:
#   0  up-to-date
#   1  error (unexpected failure or non-macOS platform)
#   2  install or update available

set -uo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "error: Xcode CLT is macOS-only" >&2
    exit 1
fi

CLT_PACKAGE="com.apple.pkg.CLTools_Executables"

# Get installed version (empty string if not installed)
installed_version=""
if pkgutil --pkg-info "$CLT_PACKAGE" &>/dev/null; then
    installed_version=$(pkgutil --pkg-info "$CLT_PACKAGE" 2>/dev/null \
        | awk '/^version:/{print $2}')
fi

# Check for available updates/installs
update_output=""
if ! update_output=$(softwareupdate -l 2>&1); then
    # softwareupdate exits non-zero on network/auth errors; if its output
    # still mentions CLT we can continue, otherwise we cannot determine state.
    if ! echo "$update_output" | grep -qi "command line tools"; then
        echo "error: softwareupdate failed to retrieve update list" >&2
        exit 1
    fi
fi

# Parse the available CLT version from the Title line, e.g.:
#   Title: Command Line Tools for Xcode 16.3, Version: 16.3, Size: ...
available_version=""
if echo "$update_output" | grep -qi "command line tools"; then
    available_version=$(echo "$update_output" \
        | grep -i "command line tools" \
        | grep -i "version:" \
        | sed 's/.*[Vv]ersion: *\([^,]*\).*/\1/' \
        | head -1 \
        | xargs)
fi

# Report and exit
if [[ -z "$installed_version" ]]; then
    echo "not installed${available_version:+ → ${available_version}}"
    exit 2
fi

if [[ -n "$available_version" ]]; then
    echo "${installed_version} → ${available_version}"
    exit 2
fi

echo "${installed_version}"
exit 0
