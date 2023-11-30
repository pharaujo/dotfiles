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
if [ -d "$HOME/.rd/bin" ]; then
  PATH="$PATH:$HOME/.rd/bin"
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
if command -v brew >/dev/null 2>&1; then
  if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
    [[ $- == *i* ]] && source "$(brew --prefix)/etc/bash_completion"
  fi
  if [[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]]; then
    source "$(brew --prefix)/etc/profile.d/autojump.sh"
  fi
  if [[ -s $(brew --prefix)/bin/fasd ]]; then
    eval "$($(brew --prefix)/bin/fasd --init auto)"
  fi
  if [[ -s $(brew --prefix)/bin/lesspipe.sh ]]; then
    export LESSOPEN="| $(brew --prefix)/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1 LESS=-R
  fi
  if [[ -s $(brew --prefix)/opt/asdf/asdf.sh ]]; then
    source "$(brew --prefix)/opt/asdf/asdf.sh"
  fi
  if [[ -s $(brew --prefix)/bin/pyenv ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    PATH="$PYENV_ROOT/bin:$PATH"
    eval "$($(brew --prefix)/bin/pyenv init --path)"
    eval "$($(brew --prefix)/bin/pyenv init -)"
  fi
  if [[ -s $(brew --prefix)/bin/fzf ]]; then
    [[ $- == *i* ]] && source "$(brew --prefix)/opt/fzf/shell/completion.bash" 2> /dev/null
    source "$(brew --prefix)/opt/fzf/shell/key-bindings.bash"
  fi
fi
if command -v docker >/dev/null 2>&1; then
  [[ $- == *i* ]] && source <(docker completion bash)
fi
source "$HOME/.custom_ps1"

#### exports
_macosx && export LC_CTYPE="pt_PT.UTF-8"
export EDITOR="nvim"
export PATH

export CLICOLOR=1
_macosx && export GREP_OPTIONS='--color=auto'
export LSCOLORS=Exfxcxdxbxegedabagacad

export GPG_TTY=$(tty)

# Record each line as it gets issued
export PROMPT_COMMAND="${PROMPT_COMMAND} history -a"
export HISTTIMEFORMAT='%F %T '
export HISTSIZE=99999
export HISTCONTROL=ignorespace
export HISTIGNORE="exit:ls:bg:fg:history:clear"
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend
