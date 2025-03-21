#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
[[ -z "${XDG_CONFIG_HOME}" ]] && CONF_HOME=${HOME}/.config || CONF_HOME=${XDG_CONFIG_HOME}

CONF_SRC=${SCRIPT_DIR}/config
mkdir -p ${CONF_HOME}
mkdir -p ${HELIX_RUNTIME}

mkdir -p ${CONF_HOME}/helix
mkdir -p ${CONF_HOME}/tmux
mkdir -p ${CONF_HOME}/lazygit
ln -s ${HELIX_RUNTIME} ${CONF_HOME}/helix/runtime
ln -sf ${CONF_SRC}/helix/config.toml ${CONF_HOME}/helix/config.toml
ln -sf ${CONF_SRC}/helix/languages.toml ${CONF_HOME}/helix/languages.toml
ln -sf ${CONF_SRC}/tmux/tmux.conf ${CONF_HOME}/tmux/tmux.conf
ln -sf ${CONF_SRC}/lazygit/config.yml ${CONF_HOME}/lazygit/config.yml
