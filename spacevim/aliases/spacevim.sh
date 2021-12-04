#!/bin/bash

spacevim() {
  if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    echo "Wrong syntax for spacevim command. Expecting: spacevim <command> [<backup_file>]" >&2
    exit 1
  elif [ "$1" = backup ]; then
    if [ -z "$2" ]; then
      ark="$(readlink -f "$(pwd)")/spacevim-$(date +%Y.%m.%dT%H.%M.%S).tar.gz"
    elif [ -d "$2" ]; then
      ark="$(readlink -f "$2")/spacevim-$(date +%Y.%m.%dT%H.%M.%S).tar.gz"
    elif ! [ -d "$(dirname "$2")" ]; then
      echo "Parent folder $(dirname "$2") doesn't exist. Aborting." >&2
      exit 1
    else
      ark="$(readlink -f "$2")"
    fi
    echo "Backuping SpaceVim into $ark"
    pushd "$HOME" > /dev/null || exit 1
    trap "popd $HOME > /dev/null" EXIT
    tar cvzf "$ark" .local/share/fonts .SpaceVim/* .SpaceVim.d/* \
      .cache/vimfiles .cache/SpaceVim/{,conf/}*.json
    echo "Backup done!"

  elif [ "$1" = restore ]; then
    if [ -z "$2" ]; then
      echo "Backup file is expected as 2nd argument for restore command" >&2
      exit 1
    fi
    ark="$(readlink -f "$2")"
    if ! [ -f "$ark" ]; then
      echo "Backup file $2 doesn't exist. Aborting." >&2
      exit 1
    fi
    echo "Restoring SpaceVim from $2"
    pushd "$HOME" > /dev/null || exit 1
    trap "popd $HOME > /dev/null" EXIT
    rm -rf .SpaceVim/* .SpaceVim.d/* .cache/vimfiles
    tar xvzf "$ark"
    echo "Restoration complete!"

  else
    echo "Unknown spacevim command $1" >&2
    exit 1
  fi
}