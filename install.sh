#!/usr/bin/env sh

# Note this just sets up the configuration files.  Installing the deps is up to you

# Doesn't handle if we are in a symlink, but :shrug:
REPO_ROOT=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
readonly REPO_ROOT

# Dependency installation
echo "Installing dependencies"
"${REPO_ROOT}/deps.sh" "${REPO_ROOT}"

# Configuration setup
echo "Configuring applications"
"${REPO_ROOT}/config.sh" "${REPO_ROOT}"
