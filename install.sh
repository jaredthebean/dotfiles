#!/usr/bin/env sh

# Note this just sets up the configuration files.  Installing the deps is up to you

readonly CONFIG_DIR="${HOME}/.config"
# Doesn't handle if we are in a symlink, but :shrug:
readonly SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
mkdir -p "${CONFIG_DIR}"

# Git
ln -s "${SCRIPT_DIR}/git" "${CONFIG_DIR}/git"

# Vim
ln -s "${SCRIPT_DIR}/vim/rc" "${HOME}/.vimrc"
mkdir -p "${HOME}/.vim"
ln -s "${SCRIPT_DIR}/vim/autoload" "${HOME}/.vim/autoload"
mkdir -p "${HOME}/.vim/plugged"

# Kitty
ln -s "${SCRIPT_DIR}/kitty" "${CONFIG_DIR}/kitty"

# ZSH
ln -s "${CONFIG_DIR}/zsh/rc" "${HOME}/.zshrc"
ln -s "${CONFIG_DIR}/zsh/aliases" "${HOME}/.zsh_aliases"
