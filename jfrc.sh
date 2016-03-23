# jfrc.sh - to be called by .bashrc, .zshrc

main() {
  local shell='sh'
  if [[ -n "${ZSH_VERSION}" ]]; then
    shell='zsh'
    setopt autocd pushdignoredups
    autoload -U promptinit && promptinit
  elif [[ ${BASH_VERSION} ]]; then
    local shell='bash'
    local comp="${HOME}/git-completion.bash"
    [[ -f ${comp} ]] && . ${comp}

#    if [[ $(which -s brew) ]] && [[ -f $(brew --prefix)/etc/bash_completion ]]; then
#      . $(brew --prefix)/etc/bash_completion
#    fi
  fi

  ## enable rbenv
  if which rbenv > /dev/null; then
    eval "$(rbenv init - ${shell})"
  fi

  ## enable pyenv
  if which pyenv > /dev/null; then  # brew install pyenv pyenv-virtualenv
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
  fi

  ## enable jenv
  if which jenv > /dev/null; then
    eval "$(jenv init -)"
  fi

  ## enable docker
  if which docker-machine > /dev/null; then
    eval "$(docker-machine env default)"
  fi

  . ${DOTFILES}/jfenv.sh
  . ${DOTFILES}/jfprompt.sh
  [[ ! "${ZSH_VERSION}" ]] && . ${DOTFILES}/jffn.sh
}
main
unset -f main
