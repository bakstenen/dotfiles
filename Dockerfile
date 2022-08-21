# basic install
FROM alpine:latest
RUN apk add --update tmux zsh git stow

ENV SHELL /bin/zsh

# install neovim and its dependencies
RUN apk add --update make gcc g++ neovim ripgrep

# build and install neovim
# RUN apk add --update build-base cmake automake autoconf libtool pkgconf coreutils curl unzip gettext-tiny-dev
# WORKDIR root
# RUN git clone https://github.com/neovim/neovim
# WORKDIR neovim
# RUN git checkout stable
# RUN make CMAKE_BUILD_TYPE=release
# install globally
# RUN make install

# install for local user only
# run rm -r build/
# run make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.local/neovim"
# run make install
# run export PATH="$HOME/.local/neovim/bin:$PATH"

# install runtimes (node, python, ripgrep)
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