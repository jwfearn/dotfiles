# jfprompt.zsh

prompt_jf() {
  PS1='%{%F{red}%}%n%{%f%}@%{%F{red}%}%m %{%F{cyan}%}%~ %{%F{white}%}%# %{%f%}'
  PS2='%_ > '
}

prompt_minimal() {
  PS1='%# '
}

# 'precmd' is a special function name known to Zsh
pjf() { eval 'precmd() { prompt_jf; }' }
pmin() { eval 'precmd() { prompt_minimal; }' }

pjf
