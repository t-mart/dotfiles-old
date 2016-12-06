# vim mode
autoload -Uz edit-command-line
bindkey -M vicmd 'v' edit-command-line
bindkey -v

# use up and down to scroll through history, or if line is not blank, history whose prefix matches current line
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# http://superuser.com/questions/476532/how-can-i-make-zshs-vi-mode-behave-more-like-bashs-vi-mode
bindkey "^?" backward-delete-char
bindkey "^W" backward-kill-word
bindkey "^H" backward-delete-char      # Control-h also deletes the previous char
bindkey "^U" backward-kill-line

# insert escaping backslashes before characters in typed urls that have other zsh meaning
# https://asciinema.org/a/2621
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic