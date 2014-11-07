
# Prompt setup

autoload -U promptinit
promptinit

# set colors for use in prompts (modern zshs allow for the use of %F{red}foo%f
# in prompts to get a red "foo" embedded, but it's good to keep these for
# backwards compatibility).
if zrcautoload colors && colors 2>/dev/null ; then
    BLUE="%{${fg[blue]}%}"
    RED="%{${fg_bold[red]}%}"
    GREEN="%{${fg[green]}%}"
    CYAN="%{${fg[cyan]}%}"
    MAGENTA="%{${fg[magenta]}%}"
    YELLOW="%{${fg[yellow]}%}"
    WHITE="%{${fg[white]}%}"
    NO_COLOR="%{${reset_color}%}"
else
    BLUE=$'%{\e[1;34m%}'
    RED=$'%{\e[1;31m%}'
    GREEN=$'%{\e[1;32m%}'
    CYAN=$'%{\e[1;36m%}'
    WHITE=$'%{\e[1;37m%}'
    MAGENTA=$'%{\e[1;35m%}'
    YELLOW=$'%{\e[1;33m%}'
    NO_COLOR=$'%{\e[0m%}'
fi

# First, the easy ones: PS2..4:

# secondary prompt, printed when the shell needs more information to complete a
# command.
PS2='\`%_> '
# selection prompt used within a select loop.
PS3='?# '
# the execution trace prompt (setopt xtrace). default: '+%N:%i>'
PS4='+%N:%i:%_> '

# gather version control information for inclusion in a prompt
if zrcautoload vcs_info; then
    # `vcs_info' in zsh versions 4.3.10 and below have a broken `_realpath'
    # function, which can cause a lot of trouble with our directory-based
    # profiles. So:
    if [[ ${ZSH_VERSION} == 4.3.<-10> ]] ; then
        function VCS_INFO_realpath () {
            setopt localoptions NO_shwordsplit chaselinks
            ( builtin cd -q $1 2> /dev/null && pwd; )
        }
    fi

    zstyle ':vcs_info:*' max-exports 2

    if [[ -o restricted ]]; then
        zstyle ':vcs_info:*' enable NONE
    fi
fi

# Change vcs_info formats for the grml prompt. The 2nd format sets up
# $vcs_info_msg_1_ to contain "zsh: repo-name" used to set our screen title.
# zstyle ':vcs_info:*' stagedstr "${GREEN}+${NO_COLOR}"
# zstyle ':vcs_info:*' unstagedstr "${YELLOW}+${NO_COLOR}"
# zstyle ':vcs_info:*' check-for-changes true
# zstyle ':vcs_info:*' actionformats "(%s)-[%b%c%u|%a]"
# zstyle ':vcs_info:*' formats "(%s)-[%b%c%u]"
zstyle ':vcs_info:*' actionformats "%s:%b|${RED}%a${NO_COLOR}"
zstyle ':vcs_info:*' formats "%s:%b"
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat "%b${RED}:${YELLOW}%r"

# Now for the fun part: The grml prompt themes in `promptsys' mode of operation

# prompt grml

#  This is the prompt as used by the grml-live system <http://grml.org>. It is
#  a rather simple one-line prompt, that by default looks something like this:
#
#      <user>@<host> <current-working-directory>[ <vcs_info-data>]%
#
#  The prompt itself integrates with zsh's prompt themes system (as you are
#  witnessing right now) and is configurable to a certain degree. In
#  particular, these aspects are customisable:
#
#      - The items used in the prompt (e.g. you can remove \`user' from
#        the list of activated items, which will cause the user name to
#        be omitted from the prompt string).
#
#      - The attributes used with the items are customisable via strings
#        used before and after the actual item.
#
#  The available items are: at, battery, change-root, date, grml-chroot,
#  history, host, jobs, newline, path, percent, rc, rc-always, sad-smiley,
#  shell-level, time, user, vcs
#
#  The actual configuration is done via zsh's \`zstyle' mechanism. The
#  context, that is used while looking up styles is:
#
#      ':prompt:grml:<left-or-right>:<subcontext>'
#
#  Here <left-or-right> is either \`left' or \`right', signifying whether the
#  style should affect the left or the right prompt. <subcontext> is either
#  \`setup' or 'items:<item>', where \`<item>' is one of the available items.
#
#  The styles:
#
#      - use-rprompt (boolean): If \`true' (the default), print a sad smiley
#        in $RPROMPT if the last command a returned non-successful error code.
#        (This in only valid if <left-or-right> is "right"; ignored otherwise)
#
#      - items (list): The list of items used in the prompt. If \`vcs' is
#        present in the list, the theme's code invokes \`vcs_info'
#        accordingly. Default (left): rc change-root user at host path vcs
#        percent; Default (right): sad-smiley
#
#  Available styles in 'items:<item>' are: pre, post. These are strings that
#  are inserted before (pre) and after (post) the item in question. Thus, the
#  following would cause the user name to be printed in red instead of the
#  default blue:
#
#      zstyle ':prompt:grml:*:items:user' pre '%F{red}'
#
#  Note, that the \`post' style may remain at its default value, because its
#  default value is '%f', which turns the foreground text attribute off (which
#  is exactly, what is still required with the new \`pre' value).

function grml_prompt_setup () {
    emulate -L zsh
    autoload -Uz vcs_info
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd prompt_$1_precmd
}

function prompt_grml_setup () {
    grml_prompt_setup grml
}

function prompt_grml_precmd_worker () {
    emulate -L zsh
    local -i vcscalled=0

    grml_prompt_addto PS1 "${left_items[@]}"
}

function grml_prompt_addto () {
    emulate -L zsh
    local target="$1"
    local lr it apre apost new v
    local -a items
    shift

    [[ $target == PS1 ]] && lr=left || lr=right
    zstyle -a ":prompt:${grmltheme}:${lr}:setup" items items || items=( "$@" )
    typeset -g "${target}="
    for it in "${items[@]}"; do
        zstyle -s ":prompt:${grmltheme}:${lr}:items:$it" pre apre \
            || apre=${grml_prompt_pre_default[$it]}
        zstyle -s ":prompt:${grmltheme}:${lr}:items:$it" post apost \
            || apost=${grml_prompt_post_default[$it]}
        zstyle -s ":prompt:${grmltheme}:${lr}:items:$it" token new \
            || new=${grml_prompt_token_default[$it]}
        typeset -g "${target}=${(P)target}${apre}"
        if (( ${+grml_prompt_token_function[$it]} )); then
            ${grml_prompt_token_function[$it]} $it
            typeset -g "${target}=${(P)target}${REPLY}"
        else
            case $it in
            battery)
                grml_typeset_and_wrap $target $new '' ''
                ;;
            change-root)
                grml_typeset_and_wrap $target $new '(' ')'
                ;;
            grml-chroot)
                if [[ -n ${(P)new} ]]; then
                    typeset -g "${target}=${(P)target}(CHROOT)"
                fi
                ;;
            vcs)
                v="vcs_info_msg_${new}_"
                if (( ! vcscalled )); then
                    vcs_info
                    vcscalled=1
                fi
                if (( ${+parameters[$v]} )) && [[ -n "${(P)v}" ]]; then
                    typeset -g "${target}=${(P)target}${(P)v}"
                fi
                ;;
            *) typeset -g "${target}=${(P)target}${new}" ;;
            esac
        fi
        typeset -g "${target}=${(P)target}${apost}"
    done
}

# These maps define default tokens and pre-/post-decoration for items to be
# used within the themes. All defaults may be customised in a context sensitive
# matter by using zsh's `zstyle' mechanism.
typeset -gA grml_prompt_pre_default \
            grml_prompt_post_default \
            grml_prompt_token_default \
            grml_prompt_token_function

function prompt_grml_precmd () {
    emulate -L zsh
    local grmltheme=grml
    local -a left_items right_items
    left_items=(newline datetime history tty shell-level vcs newline change-root user at host rc path percent)

    prompt_grml_precmd_worker
}

grml_prompt_pre_default=(
    at                ''
    datetime          '%B%F{blue}'
    colon             ''
    history           '%B'
    host              '%B%F{green}'
    jobs              '%F{red}'
    newline           ''
    path              '%B'
    percent           '%B'
    plat              '%F{yellow}'
    rc                '%B '
    shell-level       '%B%F{red}'
    tty               '%B%F{yellow}'
    user              '%B%F{green}'
    vcs               '%B%F{magenta}'
    version           '%F{green}'
)

grml_prompt_post_default=(
    at                ''
    colon             ''
    datetime          '%f '
    history           '%f%b '
    host              '%f%b'
    jobs              '%f '
    newline           '%f'
    path              '%b'
    percent           '%b '
    plat              '%f '
    rc                '%f%b '
    shell-level       '%f%b '
    tty               '%f '
    user              '%f%b'
    vcs               '%f'
    version           '%f '
)

grml_prompt_token_default=(
    at                '@'
    colon             ':'
    datetime          '%D{%Y-%m-%d %R}'
    history           'H%F{cyan}%!'
    host              '%m'
    jobs              '%j📌'
    newline           $'\n'
    path              '%40<..<%~%<<'
    percent           '%(!.%F{red}.%F{green})%#%f'
    plat              "$(uname -r)"
    rc                '↳%(?.%F{green}.%F{red})%?%1v%f'
    shell-level       '↧%L'
    tty               '%l'
    user              '%n'
    vcs               '0'
    version           "${ZSH_VERSION:-}"
)

function grml_typeset_and_wrap () {
    emulate -L zsh
    local target="$1"
    local new="$2"
    local left="$3"
    local right="$4"

    if (( ${+parameters[$new]} )); then
        typeset -g "${target}=${(P)target}${left}${(P)new}${right}"
    fi
}

prompt_themes+=( grml )
prompt_themes=( "${(@on)prompt_themes}" )

# Finally enable the prompt.
prompt grml

