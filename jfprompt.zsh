# jfprompt.zsh

precmd() { # 'precmd' is a special function name known to Zsh
  PS1='%{%F{red}%}%n%{%f%}@%{%F{red}%}%m %{%F{cyan}%}%~ %{%F{white}%}%# %{%f%}'
  PS2='%_ > '
}
