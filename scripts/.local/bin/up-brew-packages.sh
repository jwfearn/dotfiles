#!/bin/bash
# Exit codes: 0=up-to-date, 1=error, 2=updates or installs available
# --update/-u: install missing packages from ~/.Brewfile and upgrade outdated ones

UPDATE=false
for arg in "$@"; do
    case "$arg" in
        --update|-u) UPDATE=true ;;
    esac
done

if ! command -v brew &>/dev/null; then
    exit 0
fi

if [[ "$UPDATE" == true ]]; then
    if [[ -r "$HOME/.Brewfile" ]]; then
        brew bundle install --file="$HOME/.Brewfile" --upgrade-formula --upgrade-cask
    else
        brew upgrade
    fi
    brew cleanup
    exit 0
fi

# --- Read-only mode ---

# Brewfile package names (one per line)
brewfile_pkgs=""
[[ -r "$HOME/.Brewfile" ]] && \
    brewfile_pkgs=$(grep -E '^(brew|cask) "' "$HOME/.Brewfile" \
        | sed 's/^[^ ]* "//;s/".*//' | sort)

# Installed packages (one per line, "name version")
installed=$(brew list --formula --versions 2>/dev/null; \
            brew list --cask --versions 2>/dev/null)

# Outdated packages from brew (one per line, "name (current) < available")
outdated=$(brew outdated --verbose 2>/dev/null)

# For Brewfile packages not yet installed, fetch available version via brew info
uninstalled=$(comm -23 \
    <(echo "$brewfile_pkgs") \
    <(echo "$installed" | awk '{print $1}' | sort))

info_versions=""
if [[ -n "$uninstalled" ]]; then
    # brew info first line format:
    #   formula: "==> name: stable X.Y.Z ..."
    #   cask:    "==> name: X.Y.Z"
    info_versions=$(brew info $uninstalled 2>/dev/null \
        | sed -n 's/^==> \([^:]*\): \(stable \)\{0,1\}\([0-9][^ ,]*\).*/\1 \3/p')
fi

# Feed tagged lines to awk, sort output, derive exit code
output=$(
    {
        echo "$brewfile_pkgs" | grep . | awk '{print "B " $1}'
        echo "$installed"     | grep . | awk '{print "I " $1 " " $2}'
        echo "$outdated"      | grep . | awk '{gsub(/[()<]/,""); print "O " $1 " " $2 " " $4}'
        echo "$info_versions" | grep . | awk '{print "V " $1 " " $2}'
    } | awk '
    {
        type=$1; pkg=$2
        all[pkg]=1
        if      (type=="B") brewfile[pkg]=1
        else if (type=="I") installed[pkg]=$3
        else if (type=="O") { cur[pkg]=$3; avail[pkg]=$4 }
        else if (type=="V") info[pkg]=$3
    }
    END {
        for (pkg in all) {
            in_bf = (pkg in brewfile)
            c = installed[pkg]
            a = avail[pkg]
            if      (c=="" &&  in_bf) print pkg ": not installed → " (pkg in info ? info[pkg] : "unknown")
            else if (c!="" && !in_bf) print pkg ": " c " → not in Brewfile"
            else if (a!="")           print pkg ": " c " → " a
            else                      print pkg ": " c
        }
    }' | sort
)

echo "$output"
echo "$output" | grep -q "→" && exit 2 || exit 0
