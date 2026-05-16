#!/bin/bash
# Exit codes: 0=up-to-date, 1=error, 2=update or install available
# Output: current version (if installed) and available version (if not up-to-date), on one line
# --update/-u: install Homebrew if missing, or update Homebrew itself (not packages)

UPDATE=false
for arg in "$@"; do
    case "$arg" in
        --update|-u) UPDATE=true ;;
    esac
done

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
    if [[ "$UPDATE" == true ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if ! command -v brew &>/dev/null; then
            echo "error: Homebrew installation failed" >&2
            exit 1
        fi
        current=$(brew --version 2>/dev/null | awk 'NR==1{print $2}')
        echo "installed $current"
        exit 0
    fi
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

if [[ "$UPDATE" == true ]]; then
    if ! brew update; then
        echo "error: brew update failed" >&2
        exit 1
    fi
    new_current=$(brew --version 2>/dev/null | awk 'NR==1{print $2}')
    if [[ "$current" == "$new_current" ]]; then
        echo "$current"
    else
        echo "$current → $new_current"
    fi
    exit 0
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
