# basic install
FROM alpine:latest

# edit repository to edge to get latest version of packages
RUN sed -i 's|v3\.\d*|edge|' /etc/apk/repositories

# add base environment tools
RUN apk add --update zsh git lazygit tmux

# install runtimes
RUN apk add python3 py3-pip nodejs npm

# set default shell
ENV SHELL=/bin/zsh

# install editors and dependencies
RUN apk add --update make gcc g++ helix
