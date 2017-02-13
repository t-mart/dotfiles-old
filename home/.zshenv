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

# remove dupes
typeset -U path cdpath fpath manpath

# osx has /etc shell scripts that run this thing called "path_helper", whose undocumented function is to reorder path.
# i do _not_ want my path reordered, thank you very much.
# thus, we will create a proxy variable $goodpath now while our path is legit.
# and later, in .zshrc (after osx runs path_helper), we will set path=$goodpath to revert.
export GOODPATH=$PATH