#!/usr/bin/env sh
if [ $# -lt 1 ]; then
  echo "Usage: $0 <REPO_ROOT>" >&2
  exit 1
fi
readonly REPO_ROOT="$1"
. "${REPO_ROOT}/deps/lib.sh"
shift

installNodejs() {
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
  DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs
}

installPackagesWithOther() {
  local commandsToInstall="$*"
  for command in ${commandsToInstall}; do
    case "${command}" in
      nodejs)
        installNodejs
        ;;
      *)
        echo "No known installer for command '${command}'" >&2
        ;;
    esac
  done
}

# shellcheck disable=SC2068
installPackagesWithOther $@
