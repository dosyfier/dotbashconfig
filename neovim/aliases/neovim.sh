# NeoVim related aliases
# vim: set ft=bash

NEOVIM_HOME="$DOTFILES_TOOLS_DIR/nvim-linux-x86_64"

if [[ ":$PATH:" != *":$NEOVIM_HOME/bin:"* ]]; then
  export PATH="$NEOVIM_HOME/bin:$PATH"
fi

if ! [ "$(readlink -f "$(which vi)")" = "$(readlink -f "$(which nvim)")" ]; then
  alias vi=nvim
fi
