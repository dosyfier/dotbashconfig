# Vagrant related shell aliases

if [ "$win_os" = true ]; then
  export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
  export VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH="$drive_mount_root/c"
fi
