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
setopt NOMATCH
setopt GLOB_DOTS
setopt GLOB_STAR_SHORT

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