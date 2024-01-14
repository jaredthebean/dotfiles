#!/usr/bin/env sh

# Note this just sets up the configuration files.  Installing the deps is up to you

readonly CONFIG_DIR="${HOME}/.config"
# Doesn't handle if we are in a symlink, but :shrug:
readonly SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
mkdir -p "${CONFIG_DIR}"

# Git
ln -s "${SCRIPT_DIR}/git" "${CONFIG_DIR}/git"

# Vim
ln -s "${HOME}/.vimrc" "${SCRIPT_DIR}/vim/rc"
mkdir -p "${HOME}/.vim"
ln -s "${HOME}/.vim/autoload" "${SCRIPT_DIR}/vim/autoload"
mkdir -p "${HOME}/.vim/plugged"

# Kitty
ln -s "${CONFIG_DIR}/kitty" "${SCRIPT_DIR}/kitty"

# ZSH
ln -s "${HOME}/.zshrc" "${CONFIG_DIR}/zsh/rc"
ln -s "${HOME}/.zsh_aliases" "${CONFIG_DIR}/zsh/aliases"
