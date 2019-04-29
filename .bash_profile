# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
  fi
fi

function _linux() { [[ $(uname -s) == Linux* ]]; }
function _macosx() { [[ $(uname -s) == Darwin* ]]; }

#### path changes
if [ -d "/home/linuxbrew/.linuxbrew/" ]; then
  PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
fi
if [ -d "$HOME/go/bin" ]; then
  PATH="$HOME/go/bin:$PATH"
fi
if [ -d "$HOME/.cargo/bin" ]; then
  PATH="$HOME/.cargo/bin:$PATH"
fi
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi

#### sources
if command -v brew >/dev/null 2>&1 ; then
  if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
    source "$(brew --prefix)/etc/bash_completion"
  fi
  if [[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]]; then
    source "$(brew --prefix)/etc/profile.d/autojump.sh"
  fi
  if [[ -s $(brew --prefix)/bin/fasd ]]; then
      eval "$($(brew --prefix)/bin/fasd --init auto)"
  fi
  if [[ -s $(brew --prefix)/bin/lesspipe.sh ]]; then
    export LESSOPEN="| $(brew --prefix)/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1
  fi
  if [[ -s $(brew --prefix)/opt/asdf/asdf.sh ]]; then
    source "$(brew --prefix)/opt/asdf/asdf.sh"
  fi
fi
source "$HOME/.custom_ps1"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

#### exports
_macosx && export LC_CTYPE="UTF-8"
export EDITOR="vim"
export PATH

export CLICOLOR=1
_macosx && export GREP_OPTIONS='--color=auto'
export LSCOLORS=Exfxcxdxbxegedabagacad

export GPG_TTY=$(tty)

# Record each line as it gets issued
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ;} history -a"
export HISTTIMEFORMAT='%F %T '
export HISTSIZE=99999
export HISTCONTROL=ignorespace
export HISTIGNORE="exit:ls:bg:fg:history:clear"
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend
