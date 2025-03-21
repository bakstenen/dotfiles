#!/bin/bash

# Simply installs rust through rustup
# options after '--' are passed to the installer
# also pass '-y' to disaple prompt

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | zsh -s -- --no-modify-path
