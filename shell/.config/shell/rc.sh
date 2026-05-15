#!/bin/sh

_source_dir() {
    [ -d "$1" ] || return 0
    [ -n "$ZSH_VERSION" ] && setopt localoptions nullglob
    for _f in "$1"/*.sh; do
        [ -r "$_f" ] && . "$_f"
    done
}

_shell_dir="${HOME}/.config/shell"

_source_dir "${_shell_dir}/env"
_source_dir "${_shell_dir}/path"
_source_dir "${_shell_dir}/aliases"
_source_dir "${_shell_dir}/functions"
_source_dir "${_shell_dir}/local"

unset -f _source_dir
unset _shell_dir _f
