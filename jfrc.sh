# jfrc.sh - to be called by .bashrc, .zshrc

main() {
  source "${DOTFILES}/jfenv.sh"
  source "${DOTFILES}/jfprompt.sh"

  local shell='sh'
  local integrations=()

  if [ "${ZSH_VERSION}" ]; then
    shell='zsh'
    setopt autocd pushdignoredups
    autoload -U promptinit && promptinit

    ## enable unmanaged Bash completions
    integrations=( \
      "${HOME}/.fzf.zsh" \
      "${HOME}/.iterm2_shell_integration.zsh" \
    )

    ## enable Homebrew-managed Zsh completions (from: https://docs.brew.sh/Shell-Completion)
    if type brew &>/dev/null; then
      FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
    fi

  elif [ "${BASH_VERSION}" ]; then
    shell='bash'

#    if [[ $(which -s brew) ]] && [[ -f $(brew --prefix)/etc/bash_completion ]]; then
#      . $(brew --prefix)/etc/bash_completion
#    fi

    ## enable unmanaged Bash completions
    integrations=( \
      "${HOME}/.fzf.bash" \
      "${HOME}/.iterm2_shell_integration.bash" \
    )

    ## enable Homebrew-managed Bash completions (from: https://docs.brew.sh/Shell-Completion)
    if type brew &>/dev/null; then
      HOMEBREW_PREFIX="$(brew --prefix)"
      if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
        source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
      else
        for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
          [[ -r "$COMPLETION" ]] && source "$COMPLETION"
        done
      fi
    fi
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
  if which jenv > /dev/null && [ "${BASH_VERSION}" ]; then
    eval "$(jenv init -)"
  fi

  ## enable asdf
  # source "$(brew --prefix asdf)/asdf.sh" # safer
  source "/usr/local/opt/asdf/asdf.sh" # faster

  for integration in ${integrations[@]}; do
    [[ -r "${integration}" ]] && source "${integration}"
  done

  source "${DOTFILES}/jffn.sh"

  source "${HOME}/Library/Preferences/org.dystroy.broot/launcher/bash/br"
}
main
unset -f main
