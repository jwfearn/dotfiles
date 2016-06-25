# jfprompt.bash

prompt_jf() {
  PS1='\[\e[37m\]\u\[\e[0m\]@\[\e[37m\]\h \[\e[36m\]\w \[\e[37m\]\$ \[\e[0m\]'
}

prompt_minimal() {
  PS1='\$ '
}

# 'PROMPT_COMMAND' is a special environment variable name known to Bash
pjf() { PROMPT_COMMAND=prompt_jf; }
pmin() { PROMPT_COMMAND=prompt_minimal; }

pjf

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
# PS1='\$ '