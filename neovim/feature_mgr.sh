#!/bin/bash

# shellcheck source=../internal/install-base.sh
source "$(dirname "$0")/../internal/install-base.sh"

NEOVIM_VERSION=v0.9.5
NEOVIM_ARCHIVE_NAME=nvim-linux64.tar.gz
NEOVIM_DOWNLOAD_URL=https://github.com/neovim/neovim/releases/download/$NEOVIM_VERSION/$NEOVIM_ARCHIVE_NAME

get_dependencies() {
  if ! command -v git > /dev/null 2>&1; then
    echo git
  fi
  if ! command -v npm > /dev/null 2>&1; then
    echo nodejs
  fi
}

install_ubuntu() {
  _install
}

install_wsl() {
  _install
}

_install() {
  sudo bash -c "curl -L '$NEOVIM_DOWNLOAD_URL' | tar -C $DOTFILES_TOOLS_DIR -xz"
  ln -s "$FEATURE_ROOT/conf" "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
}

get_resources() {
  _get_installed_resource "$HOME/.config/nvim" "$HOME/.local/share/nvim"
}

main "$@"
