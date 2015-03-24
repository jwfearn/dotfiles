#
# .zshrc - read by zsh; IGNORED by sh, csh, ksh, tcsh, and bash

#zsh-specific resources
export PATH=ZSHRC-:$PATH:$HOME/bin:-ZSHRC

source $HOME/jfenv.sh
source $HOME/jffuncs.sh

##
# Default zsh left-aligned prompt:
# export PROMPT=%m%#

##
# My zsh left-aligned prompt:
#   "%F{magenta}"    push foreground color = magenta
#   "%m"             short hostname
#   ":"              colon
#   "%2~"            one trailing working directory component (with ~ substitution)
#   " "              space
#   "$USER"          username
#   "%#"             privilege (# = privilege, % = no privilege)
#   " "              space
#   "%f"             pop forground color
export PROMPT="%F{magenta}%m:%1~ $USER%# %f"

##
# My zsh right-aligned prompt:
#   "%F{magenta}"    push foreground color = magenta
#   "%B"             push bright (color = bright magenta)
#   "%t"             current time
#   "%b"             pop bright (color = magenta)
#   "%f"             pop forground color
export RPROMPT="%F{magenta}%B%t%b%f"
