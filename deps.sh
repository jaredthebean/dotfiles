#!/usr/bin/env sh
if [ $# -ne 1 ]; then
  echo "Usage: $0 <REPO_ROOT>" >&2
  exit 1
fi
readonly REPO_ROOT="$1"
. "${REPO_ROOT}/deps/lib.sh"

echo "Reading configuration"
while read -r provider commands; do
  case "${provider}" in
    apt)
      echo "Installing apt commands '${commands}'"
      # shellcheck disable=SC2086
      "${REPO_ROOT}/deps/providers/apt.sh" "${REPO_ROOT}" ${commands}
      ;;
    cargo)
      echo "Installing cargo commands '${commands}'"
      # shellcheck disable=SC2086
      "${REPO_ROOT}/deps/providers/cargo.sh" "${REPO_ROOT}" ${commands}
      ;;
    other)
      echo "Installing other commands '${commands}'"
      # shellcheck disable=SC2086
      "${REPO_ROOT}/deps/providers/other.sh" "${REPO_ROOT}" ${commands}
      ;;
  esac
done << EOF
$(readDepsConfig "${REPO_ROOT}/deps/config.txt")
EOF

if ! isInstalled kitty; then
  if ! kitty list-fonts | grep "Fira Code" > /dev/null; then
    echo "Need to install 'Fira Code' font" >&2
  else
    echo "Found Fira Code"
  fi
fi
