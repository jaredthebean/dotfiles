#!/usr/bin/env sh
if [ $# -lt 1 ]; then
  echo "Usage: $0 <REPO_ROOT>" >&2
  exit 1
fi
shift

readonly REPO_ROOT="$1"
readonly REPO_CONFIG_DIR="${REPO_ROOT}/config"
readonly CONFIG_DIR="${HOME}/.config"

mkdir -p "${CONFIG_DIR}"
# Git
ln -fs "${REPO_CONFIG_DIR}/git" "${CONFIG_DIR}/git"

# Vim
ln -fs "${REPO_CONFIG_DIR}/vim/rc" "${HOME}/.vimrc"
mkdir -p "${HOME}/.vim"
ln -fs "${REPO_CONFIG_DIR}/vim/autoload" "${HOME}/.vim/autoload"
ln -fs "${REPO_CONFIG_DIR}/vim/rcs" "${HOME}/.vim/rcs"
mkdir -p "${HOME}/.vim/plugged"
vim -u "${HOME}/.vim/rcs/plug.rc" +'PlugInstall --sync' +qa

# Kitty
ln -fs "${REPO_CONFIG_DIR}/kitty" "${CONFIG_DIR}/kitty"

# ZSH
ln -fs "${REPO_CONFIG_DIR}/zsh/rc" "${HOME}/.zshrc"
ln -fs "${REPO_CONFIG_DIR}/zsh/aliases" "${HOME}/.zsh_aliases"
