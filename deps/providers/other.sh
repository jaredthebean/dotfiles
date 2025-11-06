#!/usr/bin/env sh
if [ $# -lt 1 ]; then
  echo "Usage: $0 <REPO_ROOT>" >&2
  exit 1
fi
readonly REPO_ROOT="$1"
. "${REPO_ROOT}/deps/lib.sh"
shift

installNodejs() {
  curl -fsSL https://deb.nodesource.com/setup_22.x | maybeWithSudo bash -
  DEBIAN_FRONTEND=noninteractive maybeWithSudo apt-get install -y nodejs
}

installTemplateCommand() {
  mkdir -p "${HOME}/.local/bin"
  curl -fsSL 'https://raw.githubusercontent.com/jaredthebean/templates/refs/heads/main/command.sh' > "${HOME}/.local/bin/template"
  chmod +x "${HOME}/.local/bin/template"
}

installPackagesWithOther() {
  local wantedCommands="$*"
  local commandsToInstall=""
  commandsToInstall=$(unavailableCommands "${wantedCommands}")
  for command in ${commandsToInstall}; do
    case "${command}" in
      node)
        installNodejs
        ;;
      template)
        installTemplateCommand
        ;;
      *)
        echo "No known installer for command '${command}'" >&2
        ;;
    esac
  done
}

# shellcheck disable=SC2068
installPackagesWithOther $@
