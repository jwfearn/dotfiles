#!/bin/bash
# Exit codes: 0=up-to-date, 1=error, 2=update or install available
# Output: current version (if installed) and available version (if not up-to-date), on one line

get_latest_version() {
    local loc
    loc=$(curl -sI "https://github.com/Homebrew/brew/releases/latest" 2>/dev/null \
        | grep -i '^location:' \
        | tr -d '\r' \
        | sed 's|.*/tag/||' \
        | tr -d '[:space:]')
    printf '%s' "$loc"
}

if ! command -v brew &>/dev/null; then
    latest=$(get_latest_version)
    if [[ -z "$latest" ]]; then
        echo "not installed; error fetching latest version" >&2
        exit 1
    fi
    echo "not installed → $latest"
    exit 2
fi

current=$(brew --version 2>/dev/null | awk 'NR==1{print $2}')
if [[ -z "$current" ]]; then
    echo "error: could not determine installed Homebrew version" >&2
    exit 1
fi

latest=$(get_latest_version)
if [[ -z "$latest" ]]; then
    echo "error: could not fetch latest Homebrew version" >&2
    exit 1
fi

if [[ "$current" == "$latest" ]]; then
    echo "$current"
    exit 0
else
    echo "$current → $latest"
    exit 2
fi
