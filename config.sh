#! /usr/bin/env sh
if [ $# -lt 1 ]; then
  echo "Usage: $0 <REPO_ROOT>" >&2
  exit 1
fi
readonly REPO_ROOT="$1"
shift
. "${REPO_ROOT}/deps/lib.sh"

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

if ! chsh -s "$(which zsh)" "$(whoami)"; then
  echo "Trying to fix chsh PAM permissions on Ubuntu"
  maybeWithSudo sed -i 's/required/sufficient/' '/etc/pam.d/chsh'
  if ! chsh -s "$(which zsh)" "$(whoami)"; then
    echo "Didn't work: staying with default shell instead of zsh"
  else
    echo "Successfully set default shell to zsh"
  fi
fi
