#! /usr/bin/env sh
if [ $# -eq 0 ]; then
  echo "Usage: $0 <REPO_ROOT> [CONFIG_FILE]" >&2
  exit 1
fi
readonly REPO_ROOT="$1"
readonly DEPS_ROOT="${REPO_ROOT}/deps"
# shellcheck disable=SC1091
. "${DEPS_ROOT}/lib.sh"
# We want word splitting in the 'ls ...' so basename lops off the '.txt' of
# each word/filename
# shellcheck disable=SC2046
CONFIGS=$(basename -s .txt $(ls "${DEPS_ROOT}/"*.txt) | tr '\n' ' ')
readonly CONFIGS
if [ $# -eq 2 ]; then
  if ! contains "$2" "${CONFIGS}"; then
    echo "Usage: $0 <REPO_ROOT> [CONFIG_FILE]" >&2
    echo "Available configs: "
    echo "${CONFIGS}"
    exit 1
  fi
  readonly CONFIG_FILE="${DEPS_ROOT}/$2.txt"
else
  readonly CONFIG_FILE="${DEPS_ROOT}/config.txt"
fi

echo "Reading configuration"
while read -r provider commands; do
  case "${provider}" in
    apt)
      echo "Installing apt commands '${commands}'"
      # shellcheck disable=SC2086
      "${DEPS_ROOT}/providers/apt.sh" "${REPO_ROOT}" ${commands}
      ;;
    cargo)
      echo "Installing cargo commands '${commands}'"
      # shellcheck disable=SC2086
      "${DEPS_ROOT}/providers/cargo.sh" "${REPO_ROOT}" ${commands}
      ;;
    other)
      echo "Installing other commands '${commands}'"
      # shellcheck disable=SC2086
      "${DEPS_ROOT}/providers/other.sh" "${REPO_ROOT}" ${commands}
      ;;
  esac
done << EOF
$(readDepsConfig "${CONFIG_FILE}")
EOF

if isInstalled kitty; then
  if ! kitty list-fonts | grep "Fira Code" > /dev/null; then
    echo "Need to install 'Fira Code' font" >&2
  else
    echo "Found Fira Code"
  fi
fi
