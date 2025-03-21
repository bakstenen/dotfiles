#!/bin/bash

# Builds a node virtual environment in $SCRATCH. This installs some standard
# packages that are used as non-project specific cli tools and code tooling

# PATH=${SCRATCH}/packages_python/bin
# PYTHON_PATH=${SCRATCH}/packages_python

if [[ -z "${SCRATCH}" ]]; then
  source ~/.zshrc
fi

PACKAGES_DIR="${SCRATCH}/packages_python"

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

python3 -m pip install -t ${PACKAGES_DIR} virtualenv pipenv setuptools ruff python-lsp-ruff sphinx sphinx-js
