# bash-specific resources

##
# Bash prompt example:
#   "\e[0;36m"       set foreground color = cyan
#   "\h"             short hostname
#   ":"              colon
#   "\W"             one trailing working directory component (with ~ substitution)
#   " "              space
#   "\u"             username
#   "\$"             privilege (# = privilege, $ = no privilege)
#   " "              space
#   "\e[m"           clear forground color

export PS1="\e[37m\u\e[m@\e[37m\h \e[36m\w \e[37m\$ \e[m"
# export PS1="\e[0;36m$PS1\e[m"
# export PS1="\e[0;32m$USER@\h \e[0;33m\w \e[0;32m\$ \e[m"
export PS2=": "

# run bash-specific code
source ~/git-completion.bash
