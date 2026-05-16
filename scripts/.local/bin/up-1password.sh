#!/bin/bash
# Exit codes: 0=up-to-date, 1=error, 2=update or install available

get_latest_version() {
    local ver
    ver=$(curl -s "https://itunes.apple.com/lookup?bundleId=com.1password.1password" 2>/dev/null \
        | grep -o '"version":"[^"]*"' \
        | head -1 \
        | sed 's/"version":"//;s/"//')
    printf '%s' "$ver"
}

if [[ ! -d "/Applications/1Password.app" ]]; then
    latest=$(get_latest_version)
    if [[ -z "$latest" ]]; then
        echo "1Password: not installed; error fetching latest version" >&2
        exit 1
    fi
    echo "1Password: not installed → $latest (requires manual installation from App Store)"
    exit 2
fi

current=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" \
    "/Applications/1Password.app/Contents/Info.plist" 2>/dev/null)
if [[ -z "$current" ]]; then
    echo "1Password: error: could not determine installed version" >&2
    exit 1
fi

agent_sock="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
if [[ ! -S "$agent_sock" ]]; then
    if pgrep -xq "1Password"; then
        echo "1Password: SSH agent not enabled (Settings → Developer → Use the SSH agent)"
    else
        echo "1Password: SSH agent not available (1Password is not running)"
    fi
fi

dotfiles="$HOME/dotfiles"
if [[ -d "$dotfiles/.git" ]]; then
    remote=$(git -C "$dotfiles" remote get-url origin 2>/dev/null)
    if [[ "$remote" == https://github.com/* ]]; then
        ssh_url=$(printf '%s' "$remote" | sed 's|https://github.com/|git@github.com:|')
        git -C "$dotfiles" remote set-url origin "$ssh_url"
        echo "1Password: switched dotfiles remote to SSH ($ssh_url)"
    fi
fi

latest=$(get_latest_version)
if [[ -z "$latest" ]]; then
    echo "1Password: error: could not fetch latest version" >&2
    exit 1
fi

if [[ "$current" == "$latest" ]]; then
    echo "1Password: $current"
    exit 0
else
    echo "1Password: $current → $latest (requires manual update from App Store)"
    exit 2
fi
