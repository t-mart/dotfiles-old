# A common theme here is lazy loading. Instead of running compute-heavy files on startup to set up certain
# commands (e.g. nvm, virtualenvwrapper), we defer that to when the user actually runs the command.
# This is done by shimming the command with a function that:
#   1. does the expensive sourcing/loading (e.g. command pyenv)
#   1a. this sourcing/loading replaces the shim in further uses
#   2. passes the arguments of the shim onto a new invocation of the real command
# Too often are we paying the price in wait time for loading a command that will never be used in that
# terminal session!
# More info here: https://kev.inburke.com/kevin/profiling-zsh-startup-time/

# ======
# awscli
# ======
if [[ -r ${ZSH_EXTENSION_PATH}/aws_zsh_completer.sh ]]; then
  source ${ZSH_EXTENSION_PATH}/aws_zsh_completer.sh
fi

# ========
# autojump
# ========
if [[ -s "$HOME/.autojump/etc/profile.d/autojump.sh" ]]; then
    j jc jo jco() { source "$HOME/.autojump/etc/profile.d/autojump.sh"; $0 $@ }
fi

# =========
# coreutils
# =========
# See http://apple.stackexchange.com/a/69332
if [[ -d "/usr/local/opt/coreutils/libexec/gnubin" ]]; then
    export path=("/usr/local/opt/coreutils/libexec/gnubin" $path)
fi
if [[ -d "/usr/local/opt/coreutils/libexec/gnuman" ]]; then
    export manpath=("/usr/local/opt/coreutils/libexec/gnuman" $path)
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

# ===
# gpg
# ===
if type gpg &>/dev/null; then
  # needed for gpg to display password prompt on the correct tty...the one you're currently using
  export GPG_TTY=$TTY
fi

# =========
# homeshick
# =========
if [[ -r $HOME/.homesick/repos/homeshick/homeshick.sh ]]; then
    homeshick () {
        source $HOME/.homesick/repos/homeshick/homeshick.sh
        homeshick $@
    }
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
if [[ -d "${HOME}/.nvm" ]]; then
    export NVM_DIR="${HOME}/.nvm"
    nvm() {
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
        nvm $@
    }
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
    pyenv() {
        eval "$(command pyenv init -)"
        eval "$(command pyenv virtualenv-init -)"
        pyenv $@
    }

    shims=("${PYENV_ROOT}"/shims/*(:t))

    $shims () {
        unset -f $shims
        eval "$(command pyenv init -)"
        eval "$(command pyenv virtualenv-init -)"
        pyenv exec $0 $@
    }
fi


# =====
# rbenv
# =====
if [[ -d $HOME/.rbenv/bin ]]; then
  export path=(${HOME}/.rbenv/bin $path)
  rbenv() {
    eval "$(command rbenv init -)"
    rbenv $@
  }
fi

# ====
# stty
# ====
# Disable Ctrl-S terminal freezing
# (which btw, can be unfrozen with Ctrl-Q)
if type stty >/dev/null ; then
    stty -ixon
fi

# ===
# vim
# ===
if type vim &>/dev/null; then
    # needed for backup/swap file storage
    mkdir -p $HOME/.vim/undo $HOME/.vim/backup $HOME/.vim/swap
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

# ===
# xdg
# ===
# Set up XDG convention
# https://wiki.archlinux.org/index.php/XDG_Base_Directory_support
# https://specifications.freedesktop.org/basedir-spec/latest/index.html
XDG_CONFIG_HOME=$HOME/.config/
XDG_CACHE_HOME=$HOME/.cache/
XDG_DATA_HOME=$HOME/.local/share
mkdir -p $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME
