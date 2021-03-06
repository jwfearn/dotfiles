
function smart_pwd {
    local pwdmaxlen=25
    local trunc_symbol=".."
    local dir=${PWD##*/}
    local tmp=""
    pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
    NEW_PWD=${PWD/#$HOME/\~}
    local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
    if [ ${pwdoffset} -gt "0" ]
    then
        tmp=${NEW_PWD:$pwdoffset:$pwdmaxlen}
        tmp=${trunc_symbol}/${tmp#*/}
        if [ "${#tmp}" -lt "${#NEW_PWD}" ]; then
            NEW_PWD=$tmp
        fi
    fi
}

function boldtext {
    echo "\\[\\033[1m\\]"$1"\\[\\033[0m\\]"
}

function bgcolor {
    echo "\\[\\033[48;5;"$1"m\\]"
}

function fgcolor {
    echo "\\[\\033[38;5;"$1"m\\]"
}

function resetcolor {
    echo "\\[\\e[0m\\]"
}

function fancyprompt {
    PROMPT_COMMAND="smart_pwd"
    PS1="$(bgcolor 17)$(fgcolor 117)\u$(fgcolor 114)@$(fgcolor 117)\h$(fgcolor 190)$(boldtext :)$(bgcolor 232)$(fgcolor 86)\$NEW_PWD$(resetcolor)$(bgcolor 17)$(fgcolor 220)\$(__git_ps1 | tr -d ' ')$(resetcolor)$(fgcolor 208)\$ $(resetcolor)"
}

function dullprompt {
    PROMPT_COMMAND=""
    PS1="\u@\h:\w\$ "
}
case "$TERM" in
xterm-color|xterm-256color|rxvt*|screen-256color)
        fancyprompt
    ;;
*)
        dullprompt
    ;;
esac
