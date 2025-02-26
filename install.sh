#! /usr/bin/env sh

# Doesn't handle if we are in a symlink, but :shrug:
REPO_ROOT=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
readonly REPO_ROOT

# Should we force an install even if the installed version
# is detected to be the same as the current repo version
[ $# -eq 1 ] && { [ "$1" = '-f' ] || [ "$1" = '--force' ]; }
FORCE=$?
readonly FORCE

INSTALL_VERSION_FILE="${HOME}/.config/dotfiles/VERSION"
# Only re-install if the repo has updated (or we are forcing it)
if [ -f "${INSTALL_VERSION_FILE}" ] && [ ${FORCE} -ne 0 ]; then
  INSTALLED_VERSION=$(cat "${INSTALL_VERSION_FILE}")
  readonly INSTALLED_VERSION
  CURRENT_VERSION=$(cat VERSION)
  readonly CURRENT_VERSION
  if [ "${INSTALLED_VERSION}" = "${CURRENT_VERSION}" ]; then
    echo "Skipping - current version already installed"
    exit 0
  fi
fi

# Dependency installation
echo "Installing dependencies"
"${REPO_ROOT}/deps.sh" "${REPO_ROOT}"

# Configuration setup
echo "Configuring applications"
"${REPO_ROOT}/config.sh" "${REPO_ROOT}"

# Ensure installed VERSION file is updated.
mkdir -p "$(dirname "${INSTALL_VERSION_FILE}")"
cp "${REPO_ROOT}/VERSION" "${INSTALL_VERSION_FILE}"
