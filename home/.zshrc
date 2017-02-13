# consequence of things like path_helper. See note in .zshenv
export PATH=$GOODPATH

for config_file (${HOME}/.zsh/config/*.zsh); do
  source $config_file
done
