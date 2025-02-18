#!/bin/bash

FEATURE_ROOT="$(readlink -f "$(dirname "$0")")"

# shellcheck source=../internal/install-base.sh
source "$(dirname "$0")/../internal/install-base.sh"

get_dependencies() {
  if ! command -v git &>/dev/null; then
    echo git
  fi
}

install_common() {
  install_packages zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  ln -vs "$FEATURE_ROOT"/conf/zshrc "$HOME"/.zshrc
  ln -vs "$FEATURE_ROOT"/conf/p10k.zsh "$HOME"/.p10k.zsh

  sed -ri 's/^(export DOTFILES_ENABLE_EXTERNAL_PROMPT=).*$/\1true/' "$DOTFILES_ENV_FILE"
}

get_resources() {
  _get_installed_resource "$HOME/.zshrc" \
    "$HOME/.oh-my-zsh" \
    "$HOME/.p10k.zsh"
}

update() {
  git -C "$HOME"/.oh-my-zsh pull
  git -C "$HOME"/.oh-my-zsh/custom/themes/powerlevel10k pull

  gitstatus_build_info_file="$HOME/.oh-my-zsh/custom/themes/powerlevel10k/gitstatus/build.info"
  echo "Reading $gitstatus_build_info_file..."
  # shellcheck source=$HOME/.oh-my-zsh/custom/themes/powerlevel10k/gitstatus/build.info"
  source "$gitstatus_build_info_file"
  if [ -z "$gitstatus_version" ]; then
    echo "No gitstatus_version found in $gitstatus_build_info_file. Aborting" >&2
    return 1
  else
    echo "Gitstatus version: $gitstatus_version"
  fi

  curl -sSfL "https://github.com/romkatv/gitstatus/releases/download/${gitstatus_version}/gitstatusd-linux-x86_64.tar.gz" | \
    tar xzf - -C "$HOME"/.oh-my-zsh/custom/themes/powerlevel10k/gitstatus/usrbin/
}

main "$@"
