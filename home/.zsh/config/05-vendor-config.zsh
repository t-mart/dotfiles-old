extensionPath=${HOME}/.zsh/extensions

# ===============
# zsh completions
# ===============
# https://github.com/zsh-users/zsh-completions
if [[ -d ${extensionPath}/zsh-completions/src/ ]]; then
    fpath+=${extensionPath}/zsh-completions/src/
fi

# ===================
# zsh autosuggestions
# ===================
# https://github.com/zsh-users/zsh-autosuggestions
if [[ -r ${extensionPath}/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source ${extensionPath}/zsh-autosuggestions/zsh-autosuggestions.zsh
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=7'
  bindkey '^ ' autosuggest-accept
fi

# ======
# awscli
# ======
if [[ -r ${extensionPath}/aws_zsh_completer.sh ]]; then
  source ${extensionPath}/aws_zsh_completer.sh
fi

# =========
# homeshick
# =========
if [[ -r $HOME/.homesick/repos/homeshick/homeshick.sh ]]; then
  source $HOME/.homesick/repos/homeshick/homeshick.sh
fi

# ==========
# virtualenv
# ==========
# don't mess with my prompt
VIRTUAL_ENV_DISABLE_PROMPT=1

# =================
# virtualenvwrapper
# =================
if [[ -d $HOME/.virtualenvwrapper ]]; then
    export WORKON_HOME=$HOME/.virtualenvs
    export PROJECT_HOME=$HOME/code
    source $HOME/.virtualenvwrapper/virtualenvwrapper.sh
fi

# ===
# nvm
# ===
if [[ -d "${HOME}/.nvm" ]]; then
  export NVM_DIR="${HOME}/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
fi

# ===
# npm
# ===
# npm command completion script
if type complete &>/dev/null; then
  _npm_completion () {
    local words cword
    if type _get_comp_words_by_ref &>/dev/null; then
      _get_comp_words_by_ref -n = -n @ -w words -i cword
    else
      cword="$COMP_CWORD"
      words=("${COMP_WORDS[@]}")
    fi

    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${words[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
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
fi

# =====
# rbenv
# =====
if [[ -d $HOME/.rbenv/bin ]]; then
  export path=(${HOME}/.rbenv/bin $path)
  eval "$(rbenv init -)"
fi

# ===
# gpg
# ===
if type gpg &>/dev/null; then
  # needed for gpg to display password prompt on the correct tty...the one you're currently using
  export GPG_TTY=$(tty)
fi

# =====
# pyenv
# =====
if [[ -d $HOME/.pyenv/bin ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export path=($PYENV_ROOT/bin $path)
  eval "$(pyenv init -)"
fi