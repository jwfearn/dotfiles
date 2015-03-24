# jfprompt.sh

# 'precmd' is a special function name known to Zsh
[[ ${ZSH_VERSION} ]] && precmd() { myprompt; }

# 'PROMPT_COMMAND' is a special environment variable name known to Bash
[[ ${BASH_VERSION} ]] && PROMPT_COMMAND=myprompt

myprompt() {
  if [[ ${ZSH_VERSION} ]]; then
    PS1='%{%F{red}%}%n%{%f%}@%{%F{red}%}%m %{%F{cyan}%}%~ %{%F{white}%}%# %{%f%}'
    PS2='%_ > '
  elif [[ ${BASH_VERSION} ]]; then
    PS1='\[\e[37m\]\u\[\e[0m\]@\[\e[37m\]\h \[\e[36m\]\w \[\e[37m\]\$ \[\e[0m\]'
  fi
}

# if [ -n "${ZSH_VERSION}" ]; then
#   echo 'installing myprompt (zsh)'
#   [ -z $precmd_functions ] && precmd_functions=()
#   precmd_functions=($precmd_functions myprompt)
# else
#   PROMPT_COMMAND=precmd
# fi

# prompt_special() {
#   local bash_special="${1}"
#   local ret="${bash_special}"
#   if [ -z "${ZSH_VERSION}" ]; then
#     case "${bash_special}" in
#       '\h' ) ret='%m';;
#       '\u' ) ret='%n';;
#       '\w' ) ret='%~';;
#       '\$' ) ret='%#';;
#     esac
#   fi
#   printf "${ret}"  # no trailing newline
# }

# TPUT_BLACK=0
# TPUT_RED=1
# TPUT_GREEN=2
# TPUT_YELLOW=3
# TPUT_BLUE=4
# TPUT_MAGENTA=5
# TPUT_CYAN=6
# TPUT_WHITE=7

# PS1='\s-\v\$ '  # bash default
