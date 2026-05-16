# Loads secrets from ~/.config/shell/local/secrets.env via 1Password CLI.
# Secrets file format (one entry per line):
#   MY_API_KEY=op://VaultName/ItemName/field_name
# The file is gitignored — create it manually on each machine.
if [ -r "$HOME/.config/shell/local/secrets.env" ] && ! command -v op &>/dev/null; then
    echo "warning: secrets.env exists but op is not installed (run: up-1password.sh --update)" >&2
elif command -v op &>/dev/null && [ -r "$HOME/.config/shell/local/secrets.env" ]; then
    _op_out=$(op inject -i "$HOME/.config/shell/local/secrets.env" 2>/dev/null)
    if [ $? -eq 0 ]; then
        while IFS= read -r _op_line; do
            case "$_op_line" in '#'*|'') continue ;; esac
            [ -n "$_op_line" ] && export "${_op_line%%=*}=${_op_line#*=}"
        done <<< "$_op_out"
    else
        echo "warning: could not load secrets from 1Password (is it unlocked?)" >&2
    fi
    unset _op_out _op_line
fi
