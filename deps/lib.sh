#!/usr/bin/env sh

isInstalled() {
  cmd="$1"
  command -v "${cmd}"
}

contains() {
  local searchTerm="$1"
  shift
  list="$*"
  for item in ${list}; do
    if [ "${searchTerm}" = "${item}" ]; then
      return 0
    fi
  done
  return 1
}

# Reads a config file line by line - ignoring lines that start with "#"
readConfigLines() {
  local configFile="$1"
  if ! [ -f "${configFile}" ]; then
    echo "Usage: readConfig <filePath>" >&2
    return 1
  fi
  while read -r line; do
    case "${line}" in
      # Skip commments
      "#"*)
        continue
        ;;
      *)
        echo "${line}"
        ;;
    esac
  done < "${configFile}"
}

readDepsConfig() {
  # Get config file name
  # Should one configuration per line where each configuration is of the form
  # <providerName> <commandToSupply>
  local configFile="$1"
  if ! [ -f "${configFile}" ]; then
    echo "Usage: readDepsConfig <filePath>" >&2
    return 1
  fi
  local providers=""
  while read -r line; do
    # Get the name of the provider and the command name
    read -r provider command << EOF
    ${line}
EOF
    # Create new configuration line of the form
    # <providerName> <commandToSupply>...
    # where there is only one line per providerName that has all of the commands
    # it needs to supply in a space delineated list
    if ! contains "${provider}" "${providers}"; then
      providers="${providers} ${provider}"
    fi
    # Make a variable whose name is the value of the read "${provider}" variable
    # This variable will contain a space delineated list of commands that
    # provider is configured to provide
    eval "local \${${provider}}=''"
    eval "${provider}=\"\${${provider}} ${command}\""
  done << EOF
  $(readConfigLines "${configFile}")
EOF

  # Print out the new config lines
  for provider in ${providers}; do
    eval "echo \"${provider} \$${provider}\""
  done
}

append() {
  if [ "$1" = "" ]; then
    echo "$2"
  elif [ "$2" = "" ]; then
    echo "$1"
  else
    echo "$1 $2"
  fi
}

commandsToPackages() {
  if [ $# -ne 2 ]; then
    echo "Usage: commandsToPackages <configString> <commands>" >&2
    return 1
  fi
  local config="$1"
  local commands="$2"
  local packageNames=""
  local foundCommands=""

  while read -r command cmdPackageNames; do
    if contains "${command}" "${commands}"; then
      packageNames=$(append "${packageNames}" "${cmdPackageNames}")
      foundCommands=$(append "${foundCommands}" "${command}")
    fi
  done << EOF
  ${config}
EOF
  if [ ${#foundCommands} -ne ${#commands} ]; then
    echo "Wanted '${commands}' but only found '${foundCommands}'" >&2
    return 1
  fi
  echo "${packageNames}"
}
