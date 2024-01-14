#!/usr/bin/env sh

# Note this just sets up the configuration files.  Installing the deps is up to you

readonly CONFIG_DIR="${HOME}/.config"
# Doesn't handle if we are in a symlink, but :shrug:
readonly SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
mkdir -p "${CONFIG_DIR}"

# Git
ln -fs "${SCRIPT_DIR}/git" "${CONFIG_DIR}/git"

# Vim
ln -fs "${SCRIPT_DIR}/vim/rc" "${HOME}/.vimrc"
mkdir -p "${HOME}/.vim"
ln -fs "${SCRIPT_DIR}/vim/autoload" "${HOME}/.vim/autoload"
ln -fs "${SCRIPT_DIR}/vim/rcs" "${HOME}/.vim/rcs"
mkdir -p "${HOME}/.vim/plugged"
vim -u "${HOME}/.vim/rcs/plug.rc" +'PlugInstall --sync' +qa

# Kitty
ln -fs "${SCRIPT_DIR}/kitty" "${CONFIG_DIR}/kitty"

# ZSH
ln -fs "${SCRIPT_DIR}/zsh/rc" "${HOME}/.zshrc"
ln -fs "${SCRIPT_DIR}/zsh/aliases" "${HOME}/.zsh_aliases"
