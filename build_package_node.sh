#!/bin/bash

# Builds a node virtual environment in $SCRATCH. This installs some standard
# packages that are used as non-project specific cli tools and code tooling

# PATH=${SCRIPT_DIR}/packages_node/node_modules/.bin

if [[ -z "${SCRATCH}" ]]; then
  source ~/.zshrc
fi

PACKAGES_DIR="${SCRATCH}/packages_node"

if [[ -e "${PACKAGES_DIR}" ]]; then
  read -p "\"${PACKAGES_DIR}\" already exists. Rebuild? [y/n] " ans

  case $ans in
    Y ) echo "...rebuilding";;
    y ) echo "...rebuilding";;
    n ) echo "exiting";
      exit;;
    * ) echo "invalid response";
      exit 1;;
  esac

  rm -r ${PACKAGES_DIR}
fi

mkdir -p ${PACKAGES_DIR}
cd ${PACKAGES_DIR}

npm init -y
npm install --save typescript typescript-language-server @vue/language-server create-vue vite @vitejs/plugin-vue yarn
