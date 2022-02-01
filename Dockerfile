# basic install
FROM alpine:latest
RUN apk add --update tmux zsh git stow

ENV SHELL /bin/zsh

# build and install neovim
RUN apk add --update build-base cmake automake autoconf libtool pkgconf coreutils curl unzip gettext-tiny-dev
WORKDIR root
RUN git clone https://github.com/neovim/neovim
WORKDIR neovim
RUN git checkout v0.6.0
RUN make
RUN make install

# install runtimes (node, python)
RUN apk add python3 nodejs npm

# install language servers
RUN mkdir -p /root/.local/share/nvim/lsp/python
WORKDIR /root/.local/share/nvim/lsp/python
RUN npm init -y
RUN npm install pyright --save-dev

RUN mkdir -p /root/.local/share/nvim/lsp/vim
WORKDIR /root/.local/share/nvim/lsp/vim
RUN npm init -y
RUN npm install vim-language-server --save-dev