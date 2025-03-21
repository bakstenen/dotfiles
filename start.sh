#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
USER_ROOT=~/Sync/dev

docker container rm -f devenv
docker build -t devenv .
docker run -d --name devenv -i -v ${SCRIPT_DIR}:/root/dev:ro -v ${USER_ROOT}:/root/Sync/dev:ro devenv

docker exec -w /root/dev/config devenv ln -s /root/dev/config/.zshrc /root/.zshrc
docker exec -w /root/dev devenv zsh /root/dev/initialize.sh
# docker exec -w /root/dev devenv zsh /root/dev/build_package_node.sh
# docker exec -w /root/dev devenv zsh /root/dev/build_package_python.sh
# docker exec -w /root/dev devenv zsh /root/dev/build_package_rust.sh
# docker exec -w /root/dev devenv zsh hx -g fetch
# docker exec -w /root/dev devenv zsh hx -g build
docker container exec -ti devenv zsh
