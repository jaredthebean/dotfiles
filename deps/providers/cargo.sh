#!/usr/bin/env sh
if [ $# -lt 1 ]; then
  echo "Usage: $0 <REPO_ROOT>" >&2
  exit 1
fi
readonly REPO_ROOT="$1"
. "${REPO_ROOT}/deps/lib.sh"
shift

cargoAvailable() {
  isInstalled cargo
}

installRustWithCargo() {
  echo "Installing Rust+Cargo"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  # shellcheck disable=SC1091
  . "${HOME}/.cargo/env"
}

installCommandsWithCargo() {
  local commandsToInstall="$*"
  if ! cargoAvailable; then
    installRustWithCargo
  fi
  local config
  config=$(readConfigLines "${REPO_ROOT}/deps/providers/cargo.config.txt")
  local packagesToInstall
  if ! packagesToInstall=$(commandsToPackages "${config}" "${commandsToInstall}"); then
    echo "Could not convert commands '${commandsToInstall}' to package names for cargo" >&2
    return 1
  fi

  echo "Installing packages with cargo '${packagesToInstall}'"
  installCargoPackages "${packagesToInstall}"
}

installCargoPackages() {
  local packagesToInstall="$*"
  # shellcheck disable=SC2086
  cargo install ${packagesToInstall}
}

# shellcheck disable=SC2068
installCommandsWithCargo $@
