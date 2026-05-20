#!/bin/bash
# Exit codes: 0=up-to-date, 1=error, 2=symlinks need updating
# --update/-u: restow all packages to sync symlinks

UPDATE=false
for arg in "$@"; do
    case "$arg" in
        --update|-u) UPDATE=true ;;
    esac
done

DOTFILES="$HOME/dotfiles"

if ! command -v stow &>/dev/null; then
    echo "stow not installed"
    exit 2
fi

# Derive packages from top-level directories in the dotfiles repo
packages=$(find "$DOTFILES" -maxdepth 1 -mindepth 1 -type d -not -name '.git' \
    | xargs -n1 basename | sort)

# Simulate with --stow (not --restow) to detect only missing symlinks.
# --stow skips already-correct symlinks silently; --verbose=1 emits a LINK
# line only for files that need to be created. Conflicts (existing non-symlink
# files) surface as WARNING lines.
changes=$(stow --verbose=1 --simulate --stow --dir="$DOTFILES" --target="$HOME" \
    $packages 2>&1 | grep -vE '^(WARNING: in simulation mode|$)')

if [[ -z "$changes" ]]; then
    echo "symlinks up to date"
    exit 0
fi

if [[ "$UPDATE" == true ]]; then
    stow --restow --dir="$DOTFILES" --target="$HOME" $packages
else
    echo "symlinks need updating"
    echo "$changes"
fi

exit 2
