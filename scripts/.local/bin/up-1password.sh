#!/bin/bash
# Exit codes: 0=up-to-date, 1=error, 2=update or install available
# --update/-u: install or update op CLI via pkg installer (requires sudo)

UPDATE=false
for arg in "$@"; do
    case "$arg" in
        --update|-u) UPDATE=true ;;
    esac
done

result=0

get_desktop_latest_version() {
    local ver
    ver=$(curl -s "https://itunes.apple.com/lookup?bundleId=com.1password.1password" 2>/dev/null \
        | grep -o '"version":"[^"]*"' \
        | head -1 \
        | sed 's/"version":"//;s/"//')
    printf '%s' "$ver"
}

get_op_latest_version() {
    local ver
    ver=$(curl -s "https://app-updates.agilebits.com/check/1/0/CLI2/en/2.0.0/N" 2>/dev/null \
        | grep -o '"version":"[^"]*"' \
        | head -1 \
        | sed 's/"version":"//;s/"//')
    printf '%s' "$ver"
}

install_op() {
    local version=$1
    local url="https://cache.agilebits.com/dist/1P/op2/pkg/v${version}/op_apple_universal_v${version}.pkg"
    local tmp
    tmp=$(mktemp /tmp/op_XXXXXX.pkg)
    echo "1Password CLI: downloading v${version}..."
    if ! curl -fsSL "$url" -o "$tmp"; then
        echo "1Password CLI: error: download failed" >&2
        rm -f "$tmp"
        exit 1
    fi
    if ! sudo installer -pkg "$tmp" -target /; then
        echo "1Password CLI: error: installation failed" >&2
        rm -f "$tmp"
        exit 1
    fi
    rm -f "$tmp"
}

# --- 1Password desktop app ---

if [[ ! -d "/Applications/1Password.app" ]]; then
    latest=$(get_desktop_latest_version)
    if [[ -z "$latest" ]]; then
        echo "1Password: not installed; error fetching latest version" >&2
        exit 1
    fi
    echo "1Password: not installed → $latest (requires manual installation from App Store)"
    result=2
else
    desktop_current=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" \
        "/Applications/1Password.app/Contents/Info.plist" 2>/dev/null)
    if [[ -z "$desktop_current" ]]; then
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

    desktop_latest=$(get_desktop_latest_version)
    if [[ -z "$desktop_latest" ]]; then
        echo "1Password: error: could not fetch latest version" >&2
        exit 1
    fi

    if [[ "$desktop_current" == "$desktop_latest" ]]; then
        echo "1Password: $desktop_current"
    else
        echo "1Password: $desktop_current → $desktop_latest (requires manual update from App Store)"
        result=2
    fi
fi

# --- op CLI ---

op_latest=$(get_op_latest_version)
if [[ -z "$op_latest" ]]; then
    echo "1Password CLI: error: could not fetch latest version" >&2
    exit 1
fi

if ! command -v op &>/dev/null; then
    echo "1Password CLI: not installed → $op_latest"
    if [[ "$UPDATE" == true ]]; then
        install_op "$op_latest"
    else
        result=2
    fi
else
    op_current=$(op --version 2>/dev/null)
    if [[ -z "$op_current" ]]; then
        echo "1Password CLI: error: could not determine installed version" >&2
        exit 1
    fi

    if [[ "$op_current" == "$op_latest" ]]; then
        echo "1Password CLI: $op_current"
    else
        echo "1Password CLI: $op_current → $op_latest"
        if [[ "$UPDATE" == true ]]; then
            install_op "$op_latest"
        else
            result=2
        fi
    fi
fi

exit $result
