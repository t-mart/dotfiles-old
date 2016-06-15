#!/usr/bin/env zsh
# My zshrc

ZSHHOMEDIR=${HOME}/.zsh

# a place to add functions, where the name of the function is the name of the file
ZSHFUNCDIR=${ZSHHOMEDIR}/functions
[[ -d ${ZSHFUNCDIR} ]] && fpath+=${ZSHFUNCDIR}
for func in ${ZSHFUNCDIR}/*; do
  autoload -Uz ${func:t}
done

# history
HISTFILE=${HOME}/.zsh_history
SAVEHIST=10000
HISTSIZE=10000

# color ls and grep by default
typeset -ga ls_options
typeset -ga grep_options
if ls --help 2> /dev/null | grep -q GNU; then
    ls_options=( --color=auto )
elif [[ $OSTYPE == freebsd* || $OSTYPE == darwin* ]]; then
    ls_options=( -G )
fi
if grep --help 2> /dev/null | grep -q GNU || \
   [[ $OSTYPE == freebsd* ]]; then
    grep_options=( --color=auto )
fi
# if ls/grep support colors, use by default via alias
(( $#grep_options > 0 )) && alias grep='grep '${grep_options:+"${grep_options[*]}"}
(( $#ls_options > 0 )) && alias ls='ls '${ls_options:+"${ls_options[*]}"}

if [[ -r /etc/timezone ]]; then
  TZ=$(cat /etc/timezone)
fi

if type vim >/dev/null ; then
    export EDITOR=${EDITOR:-vim}
else
    export EDITOR=${EDITOR:-vi}
fi

export PAGER=${PAGER:-less}

# color setup for ls:
type dircolors > /dev/null && eval $(dircolors -b)

# support colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# report about cpu-/system-/user-time of command if running longer than
# 5 seconds
REPORTTIME=5

# Disable Ctrl-S terminal freezing
# (which btw, can be unfrozen with Ctrl-Q)
if type stty >/dev/null ; then
    stty -ixon
fi

# The function cdr allows you to change the working directory
# to a previous working directory from a list maintained automatically.
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':completion:*:*:cdr:*:*' menu selection