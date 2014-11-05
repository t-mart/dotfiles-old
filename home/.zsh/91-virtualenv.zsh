# TODO:perhaps indicate that stuff about virtualenv, but in the meantime, don't
# mess with my prompt
VIRTUAL_ENV_DISABLE_PROMPT=1

venvact(){
  [[ -r $1/bin/activate ]] && \
    source $1/bin/activate && \
    echo "Activated "$VIRTUAL_ENV || \
    echo "venvact [virtualenvdir]"
}
