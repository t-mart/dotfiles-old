##############################################
# A place for things that must be done first #
##############################################

ZSH_HOME_PATH=${HOME}/.zsh
ZSH_EXTENSION_PATH=${HOME}/.zsh/extensions
ZSH_FUNC_PATH=${ZSH_HOME_PATH}/functions

# functions
# a place to add functions, where the name of the function is the name of the file
if [[ -d ${ZSH_FUNC_PATH} ]]; then
    fpath=(${ZSH_FUNC_PATH} $fpath)
fi

autoload -U compinit
compinit


# history
export HISTFILE=${HOME}/.zsh_history
export SAVEHIST=10000
export HISTSIZE=10000


# job management
# report about cpu-/system-/user-time of command if running longer than 5 seconds
export REPORTTIME=5

# ==
# TZ
# ==
if [[ -r /etc/timezone ]]; then
  TZ=$(cat /etc/timezone)
fi
