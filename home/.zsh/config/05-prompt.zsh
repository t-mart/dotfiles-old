autoload -Uz promptinit colors vcs_info add-zsh-hook
promptinit
colors

BLUE="%{${fg[blue]}%}"
RED="%{${fg[red]}%}"
GREEN="%{${fg[green]}%}"
CYAN="%{${fg[cyan]}%}"
MAGENTA="%{${fg[magenta]}%}"
YELLOW="%{${fg[yellow]}%}"
WHITE="%{${fg[white]}%}"

BOLD_BLUE="%{${fg_bold[blue]}%}"
BOLD_RED="%{${fg_bold[red]}%}"
BOLD_GREEN="%{${fg_bold[green]}%}"
BOLD_CYAN="%{${fg_bold[cyan]}%}"
BOLD_MAGENTA="%{${fg_bold[magenta]}%}"
BOLD_YELLOW="%{${fg_bold[yellow]}%}"
BOLD_WHITE="%{${fg_bold[white]}%}"

NO_COLOR="%{${reset_color}%}"

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' max-exports 2
zstyle ':vcs_info:*' actionformats "${BOLD_CYAN}%b${NO_COLOR}|${BOLD_RED}%a${NO_COLOR}%c%u"
zstyle ':vcs_info:*' formats "${BOLD_CYAN}%b${NO_COLOR}%c%u"
zstyle ':vcs_info:*' stagedstr "${BOLD_GREEN}Δ${NO_COLOR}"
zstyle ':vcs_info:*' unstagedstr "${BOLD_RED}Δ${NO_COLOR}"
zstyle ':vcs_info:*' check-for-changes true

set_terminal_title () {
    print -Pn "\e]0;%n@%M %~\a"
}

prompt_tim_precmd () {
    vcs_info

    print -P
    print -P ${p_date} ${p_user_at_host} ${vcs_info_msg_0_}
}

prompt_tim_setup () {

    p_date="${BOLD_WHITE}%D{%FT%T%Z}${NO_COLOR}"
    p_return_code="↳ %(?.${BOLD_GREEN}.${BOLD_RED})%?${NO_COLOR}"
    p_history_number="H${BOLD_YELLOW}%!${NO_COLOR}"
    p_user_at_host="${BOLD_GREEN}%n${BOLD_WHITE}@${BOLD_GREEN}%M${NO_COLOR}"
    p_priv_level="${BOLD_MAGENTA}%#${NO_COLOR}"
    p_path="%{%U%}${BOLD_BLUE}%~${NO_COLOR}%{%u%}"

    autoload -Uz vcs_info
    autoload -Uz add-zsh-hook

    add-zsh-hook precmd prompt_tim_precmd
    add-zsh-hook precmd set_terminal_title

    PS1="${p_path} ${p_return_code} ${p_history_number} ${p_priv_level} "
    # when the shell needs more information to complete a command.
    PS2="${MAGENTA}%_ ⏩${NO_COLOR} "
    # selection prompt used within a select loop.
    PS3="?# "
    # the execution trace prompt (setopt xtrace).
    PS4="+%N:%i:%_> "
}

prompt_themes+=( tim )

prompt tim

# Ensure that the prompt is redrawn when the terminal size changes.
TRAPWINCH() {
  zle && zle -R
}

function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
