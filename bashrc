# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

function get_scm_branch {
    git_branch=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(git:\1)/')
    if [ -n "$git_branch"  ]; then
        echo $git_branch
        return 0
    fi
    hg_branch=$(hg branch 2> /dev/null | sed -e 's/\(.*\)/(hg:\1)/')
    if [ -n "$hg_branch" ]; then
        echo $hg_branch
        return 0
    fi
    if [[ -d .svn ]]; then
        local _svn_info=$(svn info 2> /dev/null)
        local _svn_root=$(echo "$_svn_info" | sed -ne 's#^Repository Root: ##p')
        #local _svn_url=$(echo "$_svn_info" | sed -ne 's#^URL: ##p')
        #local _svn_branch=$(echo $_svn_url | sed -e 's#^'"$_svn_root"'##g')
        local _svn_base=$(basename $_svn_root)
        local _svn_rev=$(echo "$_svn_info" | sed -ne '/^Revision: \([0-9]*\).*$/s//\1/p')
        echo "(svn:$_svn_base@$_svn_rev)"
        return 0
    fi
}

if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ ' #default ubuntu PS1
    #PS1='${debian_chroot:+($debian_chroot)}\[\e]2;\u@\H \w\a\e[32;1m\]>\[\e[0m\] ' #info on titlebar
    #PS1='$(if [ $? = 0 ]; then echo \[\e[32m\]^_^\[\e[0m\]; else echo \[\e[31m\]O_O\[\e[0m\]; fi)[\u@\h:\w]\\$ ' # exit status emoticons
    if [[ ${EUID} == 0 ]] ; then
        PS1='\[\033[0;33m\][\!]\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] ' # based on gentoo PS1
    else
        PS1='\[\033[0;33m\][\!]\[\033[01;32m\]\u@\h\[\033[01;34m\]:\w\[\033[0;32m\]$(get_scm_branch)\[\033[01;34m\]\$\[\033[00m\] '
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi
