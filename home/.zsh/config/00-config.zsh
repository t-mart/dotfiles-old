
##############################################
# A place for things that must be done first #
##############################################

ZSH_HOME_PATH=${HOME}/.zsh
ZSH_EXTENSION_PATH=${HOME}/.zsh/extensions
ZSH_FUNC_PATH=${ZSH_HOME_PATH}/functions

autoload -U compinit
compinit

# ======
# awscli
# ======
if [[ -r ${ZSH_EXTENSION_PATH}/aws_zsh_completer.sh ]]; then
  source ${ZSH_EXTENSION_PATH}/aws_zsh_completer.sh
fi

# ===
# cdr
# ===
# The function cdr allows you to change the working directory
# to a previous working directory from a list maintained automatically.
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# ==============
# dircolors / ls
# ==============
# color setup for ls:
type dircolors > /dev/null && eval $(dircolors -b)
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

# =========
# functions
# =========
# a place to add functions, where the name of the function is the name of the file
[[ -d ${ZSH_FUNC_PATH} ]] && fpath+=${ZSH_FUNC_PATH}
for func in ${ZSH_FUNC_PATH}/*; do
  autoload -Uz ${func:t}
  compinit
done

# ===
# gpg
# ===
if type gpg &>/dev/null; then
  # needed for gpg to display password prompt on the correct tty...the one you're currently using
  export GPG_TTY=$(tty)
fi

# =======
# history
# =======
export HISTFILE=${HOME}/.zsh_history
export SAVEHIST=10000
export HISTSIZE=10000

# =========
# homeshick
# =========
if [[ -r $HOME/.homesick/repos/homeshick/homeshick.sh ]]; then
  source $HOME/.homesick/repos/homeshick/homeshick.sh
  fpath=($HOME/.homesick/repos/homeshick/completions $fpath)
fi

# ====
# less
# ====
export PAGER=less
# support colors and styles in less
export LESS_TERMCAP_mb=$'\E[01;31m'     # start blink
export LESS_TERMCAP_md=$'\E[01;31m'     # start bold
export LESS_TERMCAP_so=$'\E[01;44;33m'  # start standout
export LESS_TERMCAP_ue=$'\E[0m'         # start underline
export LESS_TERMCAP_me=$'\E[0m'         # stop bold, blink, underline
export LESS_TERMCAP_se=$'\E[0m'         # stop standout
export LESS_TERMCAP_us=$'\E[01;32m'     # stop underline

# ==============
# job management
# ==============
# report about cpu-/system-/user-time of command if running longer than 5 seconds
export REPORTTIME=5

# ===
# npm
# ===
# npm command completion script
_npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
}
compctl -K _npm_completion npm

# ===
# nvm
# ===
# nvm _is_ slow to load, but it's really node's fault:
# https://github.com/creationix/nvm/issues/703
# instead, to workaround, adding --no-use to the line that source nvm.sh, and manually running nvm use when needed
if [[ -d "${HOME}/.nvm" ]]; then
  export NVM_DIR="${HOME}/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use
fi

# ===
# pip
# ===
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] ) )
}
compctl -K _pip_completion pip

# =====
# pyenv
# =====
if [[ -d $HOME/.pyenv/bin ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export path=(${PYENV_ROOT}/bin $path)
  eval "$(pyenv init -)"
fi


# =====
# rbenv
# =====
if [[ -d $HOME/.rbenv/bin ]]; then
  export path=(${HOME}/.rbenv/bin $path)
  eval "$(rbenv init -)"
fi

# ====
# stty
# ====
# Disable Ctrl-S terminal freezing
# (which btw, can be unfrozen with Ctrl-Q)
if type stty >/dev/null ; then
    stty -ixon
fi

# ==
# TZ
# ==
if [[ -r /etc/timezone ]]; then
  TZ=$(cat /etc/timezone)
fi

# ===
# vim
# ===
if type vim &>/dev/null; then
  # needed for backup/swap file storage
  for vimdir in undo backup swap; do
    mkdir -p $HOME/.vim/$vimdir
  done
fi
if type vim >/dev/null ; then
    export EDITOR=vim
elif type vi >/dev/null ; then
    export EDITOR=vi
fi
# for vim mode in the zle, wait 0.1 seconds to switch to normal mode (not 0.4, the default)
export KEYTIMEOUT=1

# ==========
# virtualenv
# ==========
# don't mess with my prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

# =================
# virtualenvwrapper
# =================
if [[ -d $HOME/.virtualenvwrapper ]]; then
    export WORKON_HOME=$HOME/.virtualenvs
    export PROJECT_HOME=$HOME/code
    source $HOME/.virtualenvwrapper/virtualenvwrapper.sh 2>/dev/null
fi

# ===
# xdg
# ===
# Set up XDG convention
# https://wiki.archlinux.org/index.php/XDG_Base_Directory_support
# https://specifications.freedesktop.org/basedir-spec/latest/index.html
XDG_CONFIG_HOME=$HOME/.config/
XDG_CACHE_HOME=$HOME/.cache/
XDG_DATA_HOME=$HOME/.local/share
for xdgdir in $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME; do
    mkdir -p $xdgdir
done
