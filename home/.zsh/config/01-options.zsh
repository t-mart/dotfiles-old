setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt share_history
setopt hist_verify

setopt auto_cd
setopt extended_glob
setopt longlistjobs
setopt nomatch

# report the status of backgrounds jobs immediately
setopt notify

# whenever a command completion is attempted, make sure the entire command path
# is hashed first.
setopt hash_list_all

# not just at the end
setopt completeinword

# Don't send SIGHUP to background processes when the shell exits.
setopt nohup

# make cd push the old directory onto the directory stack.
setopt auto_pushd

# avoid "beep"ing
setopt nobeep

# its okay to have the stack contain the same dir
setopt no_pushd_ignore_dups

# match dotfiles plz
setopt globdots

# don't error out when unset parameters are used
setopt unset

# allow comments in interactive shells
setopt interactivecomments

# don't correct stuff, dammit
setopt no_correct
setopt no_correct_all

setopt menucomplete
