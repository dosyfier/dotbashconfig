#!/bin/bash

source "$(dirname "$0")/../internal/install-base.sh"

install_centos() {
  install_packages ruby
}

install_redhat() {
  install_centos
}

install_ubuntu() {
  install_repo brightbox/ruby-ng
  install_packages ruby ruby-dev
}

install_winbash() {
  install_ubuntu
}
  
# shellcheck disable=SC2068
# Unquoted array expansion is here expected
main $@

