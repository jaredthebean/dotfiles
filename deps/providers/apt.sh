#!/usr/bin/env sh
if [ $# -lt 1 ]; then
  echo "Usage: $0 <REPO_ROOT>" >&2
  exit 1
fi
readonly REPO_ROOT="$1"
. "${REPO_ROOT}/deps/lib.sh"
shift

aptAvailable() {
  isInstalled apt-get
}

installCommandsWithApt() {
  local wantedCommands="$*"
  if ! aptAvailable; then
    echo "apt not available as package manager." >&2
    return 1
  fi
  local commandsToInstall=""
  commandsToInstall=$(unavailableCommands "${wantedCommands}")
  local config
  config=$(readConfigLines "${REPO_ROOT}/deps/providers/apt.config.txt")
  local packagesToInstall
  if ! packagesToInstall=$(commandsToPackages "${config}" "${commandsToInstall}"); then
    echo "Could not convert commands '${commandsToInstall}' to package names for apt" >&2
    return 1
  fi
  echo "Installing packages with apt '${packagesToInstall}'"
  installAptPackages "${packagesToInstall}"
}

installAptPackages() {
  local packagesToInstall="$*"
  apt-get update
  # shellcheck disable=SC2086
  DEBIAN_FRONTEND=noninteractive apt-get -y install ${packagesToInstall} build-essential
}

# shellcheck disable=SC2068
installCommandsWithApt $@
