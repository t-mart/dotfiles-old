# listing stuff
# I don't think I'll use these too often, but they're good examples of
# leveraging zsh
    alias la='ls -la '${ls_options:+"${ls_options[*]}"}
alias lad='ls -d .*(/) '${ls_options:+"${ls_options[*]}"}
# Only show dot-files
alias lsa='ls -a .*(.) '${ls_options:+"${ls_options[*]}"}
# Only files with setgid/setuid/sticky flag
alias lss='ls -l *(s,S,t) '${ls_options:+"${ls_options[*]}"}
# Only show symlinks
alias lsl='ls -l *(@) '${ls_options:+"${ls_options[*]}"}
# Display only executables
alias lsx='ls -l *(*) '${ls_options:+"${ls_options[*]}"}
# Display world-{readable,writable,executable} files
alias lsw='ls -ld *(R,W,X.^ND/) '${ls_options:+"${ls_options[*]}"}
# Display the ten biggest files
alias lsbig="ls -flh *(.OL[1,10]) "${ls_options:+"${ls_options[*]}"}
# Only show directories
alias lsd='ls -d *(/) '${ls_options:+"${ls_options[*]}"}
# Only show empty directories
alias lse='ls -d *(/^F) '${ls_options:+"${ls_options[*]}"}
# Display the ten newest files
alias lsnew="ls -rtlh *(D.om[1,10]) "${ls_options:+"${ls_options[*]}"}
# Display the ten oldest files
alias lsold="ls -rtlh *(D.Om[1,10]) "${ls_options:+"${ls_options[*]}"}
# Display the ten smallest files
alias lssmall="ls -Srl *(.oL[1,10]) "${ls_options:+"${ls_options[*]}"}
# Display the ten newest directories and ten newest .directories
alias lsnewdir="ls -rthdl *(/om[1,10]) .*(D/om[1,10]) "${ls_options:+"${ls_options[*]}"}
# Display the ten oldest directories and ten oldest .directories
alias lsolddir="ls -rthdl *(/Om[1,10]) .*(D/Om[1,10]) "${ls_options:+"${ls_options[*]}"}

venvact () {
  venv_path_file=".ve"

  if (( ${#argv} == 1 )) then;
    venv_path_file=${1}
  fi

  if [ ! -f $venv_path_file ]; then
    echo "Could not find file ${venv_path_file}"
    return 1
  fi

  venvact_activate_path=$(cat $venv_path_file)
  if [ $? -ne 0 ]; then
    echo "Problem running getting contents of ${venv_path_file} (cat)"
    return 1
  fi

  if [ ! -f $venvact_activate_path ]; then
    echo "Path ${venvact_activate_path} (read from ${venv_path_file}) does not exist"
    return 1
  fi

  source $venvact_activate_path
  if [ $? -eq 0 ]; then
    echo "Activated virtualenv ${VIRTUAL_ENV}"
    return 0
  else
    echo "There was a problem activating the virtualenv"
    return 1
  fi
}

# Backup file {\rm to file\_timestamp}
bk() {
    emulate -L zsh
    cp -b $1 $1_`date --iso-8601=m`
}

# broken_links [-r|--recursive] [<path>]
# find links whose targets don't exist and print them. If <path> is given, look
# at that path for the links. Otherwise, the current directory is used is used.
# If --recursive is specified, look recursively through path.
broken_links () {
  find_recurse_option="-maxdepth 1"
  search_path=$(pwd)

  while test $# != 0
  do
    case "$1" in
      -r|--recursive)
        unset find_recurse_option
        ;;
      *)
        if test -d "$1"
        then
          search_path="$1"
        else
          echo "$1 not a valid path or option"
          return 1
        fi
        ;;
    esac
    shift
  done

  find $search_path ${=find_recurse_option} -type l ! -exec test -e {} \; -print
}

# cd to directoy and list files
cl() {
    emulate -L zsh
    cd $1 && ls -a
}

# smart cd function, allows switching to /etc when running 'cd /etc/fstab'
cd() {
    if (( ${#argv} == 1 )) && [[ -f ${1} ]]; then
        [[ ! -e ${1:h} ]] && return 1
        print "Correcting ${1} to ${1:h}"
        builtin cd ${1:h}
    else
        builtin cd "$@"
    fi
}

# Create Directoy and cd to it
mkcd() {
    if (( ARGC != 1 )); then
        printf 'usage: mkcd <new-directory>\n'
        return 1;
    fi
    if [[ ! -d "$1" ]]; then
        command mkdir -p "$1"
    else
        printf '`%s'\'' already exists: cd-ing.\n' "$1"
    fi
    builtin cd "$1"
}

# Create temporary directory and cd to it
cdt() {
    local t
    t=$(mktemp -d)
    echo "$t"
    builtin cd "$t"
}

# List files which have been accessed within the last {\it n} days, {\it n} defaults to 1
accessed() {
    emulate -L zsh
    print -l -- *(a-${1:-1})
}

# List files which have been changed within the last {\it n} days, {\it n} defaults to 1
changed() {
    emulate -L zsh
    print -l -- *(c-${1:-1})
}

# List files which have been modified within the last {\it n} days, {\it n} defaults to 1
modified() {
    emulate -L zsh
    print -l -- *(m-${1:-1})
}

