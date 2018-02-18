local dirpaths=( /sbin /bin /usr/sbin /usr/bin /usr/local/sbin /usr/local/bin ${HOME}/bin )

for d in $dirpaths; do
  if [[ -d "$d" ]]; then
    path=($d $path)
  fi
done

# remove dupes
typeset -U path cdpath fpath manpath

# osx has /etc shell scripts that run this thing called "path_helper", whose undocumented function is to reorder path.
# i do _not_ want my path reordered, thank you very much.
# thus, we will create a proxy variable $goodpath now while our path is legit.
# and later, in .zshrc (after osx runs path_helper), we will set path=$goodpath to revert.
typeset -a goodpath=( $path )
