#!/bin/bash

# shellcheck source=../internal/install-base.sh
source "$(dirname "$0")/../internal/install-base.sh"

NEOVIM_VERSION=v0.10.4
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

_download_and_install() {
  sudo bash -c "curl -sSfL '$NEOVIM_DOWNLOAD_URL' | tar -C $DOTFILES_TOOLS_DIR -xz"
}

install_common() {
  _download_and_install
  ln -sfn "$FEATURE_ROOT/conf" "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
}

get_resources() {
  _get_installed_resource "$HOME/.config/nvim" "$HOME/.local/share/nvim"
}

update() {
  if command -v nvim &> /dev/null && [ "$(nvim -v | head -n 1 | awk '{print $NF}')" = $NEOVIM_VERSION ]; then
    echo "Neovim is up-to-date (version: $NEOVIM_VERSION). Skipping."
  else
    _download_and_install
  fi
}

main "$@"
