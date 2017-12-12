# consequence of things like path_helper. See note in .zshenv
export PATH=$GOODPATH

# Set to true for profiling
PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
    PS4=$'%D{%s.%6.} %N:%i> '
#    profilelog=$HOME/zshprofile/startlog.$$
    profilelog=$HOME/zshprofile/startlog
    mkdir -p $(dirname $profilelog)


    echo "Profiling your shell startup scripts. Logging to ${profilelog}..."
    exec 3>&2 2>$profilelog
    setopt xtrace prompt_subst
fi

for config_file in ${HOME}/.zsh/config/*.zsh; do
  source $config_file
done

if [[ "$PROFILE_STARTUP" == true ]]; then
    unsetopt xtrace
    echo "Profile complete."

    args () { echo $# }

    profilestats () {
        while read line; do
            set -A parts ${=line}
            line_time=${parts:0:1}
            if [[ $line_time =~ "^\d+\.\d+$" ]]; then
                line_diff=$(( ${line_time} - ${last_time=$line_time} ))
                last_time=$line_time
                echo ${line_diff} ${line}
            fi
        done
    }

    exec 2>&3 3>&-
fi
