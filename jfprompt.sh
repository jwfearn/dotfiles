# jfprompt.sh

if [ ${ZSH_VERSION} ]; then
  source "${DOTFILES}/jfprompt.zsh"
elif [ ${BASH_VERSION} ]; then
  source "${DOTFILES}/jfprompt.bash"
fi
