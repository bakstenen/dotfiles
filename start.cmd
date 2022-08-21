docker container rm -f devenv
docker build -t vim_devenv .
docker run -d --name devenv -i -v %~dp0.dotfiles:/root/.dotfiles:ro vim_devenv
docker exec -w /root/.dotfiles devenv stow nvim
docker exec -w /root/.dotfiles devenv stow zsh
docker exec -w /root/.dotfiles devenv stow tmux
docker exec -w /root/.dotfiles devenv nvim --headless +PlugInstall +qall
docker container exec -ti devenv zsh