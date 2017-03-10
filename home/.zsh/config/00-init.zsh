##############################################
# A place for things that must be done first #
##############################################

ZSH_HOME_PATH=${HOME}/.zsh
ZSH_EXTENSION_PATH=${HOME}/.zsh/extensions
ZSH_COMPLETION_PATH=${ZSH_HOME_PATH}/completions
ZSH_FUNCTION_PATH=${ZSH_HOME_PATH}/functions

# completions
if [[ -d ${ZSH_COMPLETION_PATH} ]]; then
    fpath=(${ZSH_COMPLETION_PATH} $fpath)
fi
if [[ -d $HOME/.homesick/repos/homeshick/completions ]]; then
  fpath=($HOME/.homesick/repos/homeshick/completions $fpath)
fi

# functions
if [[ -d ${ZSH_FUNCTION_PATH} ]]; then
    fpath=(${ZSH_FUNCTION_PATH} $fpath)
    for func in ${ZSH_FUNCTION_PATH}/*; do
        autoload -Uz ${func:t}
    done
fi

# compinit
autoload -U compinit
compinit

# history
export HISTFILE=${HOME}/.zsh_history
export SAVEHIST=10000
export HISTSIZE=10000

# job management
# report about cpu-/system-/user-time of command if running longer than 5 seconds
export REPORTTIME=5

# TZ
if [[ -r /etc/timezone ]]; then
  TZ=$(cat /etc/timezone)
fi
