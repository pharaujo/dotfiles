export PATH="$HOME/bin:$PATH"
export PATH="$PATH:$HOME/.cargo/bin"

if command -v brew >/dev/null 2>&1 ; then
  if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
    source "$(brew --prefix)/etc/bash_completion"
  fi
  if [ -f "$(brew --prefix)/etc/grc.bashrc" ]; then
    source "$(brew --prefix)/etc/grc.bashrc"
  fi
fi

. ~/.custom_ps1

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

export LC_CTYPE="UTF-8"
export EDITOR="vim"

export CLICOLOR=1
export GREP_OPTIONS='--color=auto'
export LSCOLORS=Exfxcxdxbxegedabagacad

export HISTTIMEFORMAT='%Y-%m-%d %H:%M:%s '
export HISTSIZE=50000
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend
