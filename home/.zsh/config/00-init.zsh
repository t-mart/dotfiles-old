##############################################
# A place for things that must be done first #
##############################################

# Documentation: http://zsh.sourceforge.net/Doc/Release/Options.html
# Changing Directories
######################
setopt AUTO_CD
setopt AUTO_PUSHD

# Completion
############
setopt HASH_LIST_ALL
setopt COMPLETE_IN_WORD
setopt MENUCOMPLETE

# Expansion and Globbing
########################
setopt EXTENDED_GLOB
setopt EQUALS
setopt NOMATCH
setopt GLOB_DOTS
setopt GLOB_STAR_SHORT
setopt REMATCH_PCRE

# History
#########
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt HIST_VERIFY

# Initialisation
################

# Input/Output
##############
setopt INTERACTIVE_COMMENTS
setopt NO_CORRECT
setopt NO_CORRECT_ALL

# Job Control
#############
setopt LONG_LIST_JOBS
setopt CHECK_JOBS
setopt HUP
setopt NOTIFY

# Prompting
###########

# Scripts and Functions
#######################

# Shell Emulation
#################

# Shell State
#############

# Zle
#####
setopt NOBEEP


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
