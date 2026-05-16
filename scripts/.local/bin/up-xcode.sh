#!/bin/bash
# Exit codes: 0=up-to-date, 1=error, 2=update or install available

get_latest_version() {
    local ver
    ver=$(curl -s "https://itunes.apple.com/lookup?id=497799835" 2>/dev/null \
        | grep -o '"version":"[^"]*"' \
        | head -1 \
        | sed 's/"version":"//;s/"//')
    printf '%s' "$ver"
}

# xcodebuild -version fails when only CLT is installed
if ! xcodebuild -version &>/dev/null; then
    latest=$(get_latest_version)
    if [[ -z "$latest" ]]; then
        echo "Xcode: not installed; error fetching latest version" >&2
        exit 1
    fi
    echo "Xcode: not installed → $latest (requires manual installation from App Store)"
    exit 2
fi

current=$(xcodebuild -version 2>/dev/null | awk 'NR==1{print $2}')
if [[ -z "$current" ]]; then
    echo "Xcode: error: could not determine installed version" >&2
    exit 1
fi

latest=$(get_latest_version)
if [[ -z "$latest" ]]; then
    echo "Xcode: error: could not fetch latest version" >&2
    exit 1
fi

if [[ "$current" == "$latest" ]]; then
    echo "Xcode: $current"
    exit 0
else
    echo "Xcode: $current → $latest (requires manual update from App Store)"
    exit 2
fi
