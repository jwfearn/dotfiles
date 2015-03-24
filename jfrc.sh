# jfrc.sh - to be called by .bashrc, .zshrc

main() {
  local shell='bash'
  if [ -n "${ZSH_VERSION}" ]; then
    ## zsh
    shell='zsh'
    setopt autocd pushdignoredups
    autoload -U promptinit && promptinit
  else
    ## assume bash
    . ${HOME}/git-completion.bash
  fi

  ## enable rbenv shims and autocompletion
  if which rbenv > /dev/null; then eval "$(rbenv init - ${shell})"; fi

  ## enable pyenv shims and other features
  export PATH="${HOME}/.pyenv/bin:$PATH"
  if which pyenv > /dev/null; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
  fi

  . ${DOTFILES}/jfenv.sh
  . ${DOTFILES}/jfprompt.sh
  [ ! "${ZSH_VERSION}" ] && . ${DOTFILES}/jffn.sh
}
main
unset -f main
