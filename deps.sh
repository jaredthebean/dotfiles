#!/usr/bin/env sh

readonly COMMANDS="1password bat cargo eza git kitty rg ssh vim zsh"

for cmd in ${COMMANDS}; do
  cmdPath=$(command -v "${cmd}")
  if [ ! $? -eq 0 ] ; then
    echo "Need to install '${cmd}'";
  else
    echo "Found '${cmd}' at '${cmdPath}'";
  fi
done

if ! command -v "kitty" > /dev/null; then
  if ! kitty list-fonts | grep "Fira Code" > /dev/null; then
    echo "Need to install 'Fira Code' font";
  else
    echo "Found Fira Code";
  fi
fi
