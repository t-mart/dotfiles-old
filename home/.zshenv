pathstoadd=()

addifexists() {
  [[ -d $1 ]] && pathstoadd+=($1)
}

addifexists ${HOME}/bin
addifexists /usr/local/bin
addifexists /usr/local/sbin
addifexists /usr/bin
addifexists /usr/sbin
addifexists /bin
addifexists /sbin

# add to path
path=($pathstoadd $path)

#

# remove dupes
typeset -U path cdpath fpath manpath
