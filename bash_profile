if command -v brew >/dev/null 2>&1 ; then
  if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
    source "$(brew --prefix)/etc/bash_completion"
  fi
  if [ -f "$(brew --prefix)/etc/grc.bashrc" ]; then
    source "$(brew --prefix)/etc/grc.bashrc"
fi

. ~/.custom_ps1

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

export PATH="~/bin:$PATH"

export LC_CTYPE="UTF-8"
export EDITOR="vim"

export CLICOLOR=1
export GREP_OPTIONS='--color=auto'
export LSCOLORS=Exfxcxdxbxegedabagacad

