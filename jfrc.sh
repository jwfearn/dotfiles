# jfrc.sh - to be called by .bashrc, .zshrc

main() {
  source "${DOTFILES}/jfenv.sh"
  source "${DOTFILES}/jfprompt.sh"

  local shell='sh'
  if [[ -n "${ZSH_VERSION}" ]]; then
    shell='zsh'
    setopt autocd pushdignoredups
    autoload -U promptinit && promptinit
  elif [[ ${BASH_VERSION} ]]; then
    local shell='bash'
    local git_integration="${HOME}/git-completion.bash"
    [[ -f "${git_integration}" ]] && source "${git_integration}"
    local iterm_integration="${HOME}/.iterm2_shell_integration.bash"
    [[ -f "${iterm_integration}" ]] && source "${iterm_integration}"

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

  [[ ! "${ZSH_VERSION}" ]] && source ${DOTFILES}/jffn.sh
}
main
unset -f main
