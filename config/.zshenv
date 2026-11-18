export PATH="$HOME/.local/bin:$PATH"
export EDITOR=vim

_nvm_default=(${NVM_DIR:-$HOME/.nvm}/versions/node/*(Nn[-1]))
if [[ -n $_nvm_default ]]; then
  path=($_nvm_default/bin $path)
  MANPATH=$_nvm_default/share/man:$MANPATH
  export NODE_PATH=$_nvm_default/lib/node_modules
fi
unset _nvm_default
