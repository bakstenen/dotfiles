# setup
# SCRATCH     : packages and virtual envs
# DEVENV_ROOT : root folder where all the config files live
# USER_ROOT   : root folder where all projects live
export SCRATCH=~/SCRATCH
export DEVENV_ROOT=~/Sync/dev/devenv
export USER_ROOT=~/Sync/dev

# LOOKS
PROMPT='%F{red}%B(%M)%b%f %F{yellow}%4c %F{14}❯%f '

# RUNTIMES
typeset -TUx LD_LIBRARY_PATH ld_library_path 
typeset -TUx PYTHONPATH python_path
path=(
    /opt/homebrew/bin
    $SCRATCH/.cargo/bin
    $SCRATCH/packages_node/node_modules/.bin
    $SCRATCH/packages_python/bin
    $DEVENV_ROOT/scripts
    $path
)
python_path=(
    $SCRATCH/packages_python
)
ld_library_path=(
    $ld_library_path
)

# ENV VARS
export HELIX_RUNTIME=$SCRATCH/helix_runtime

# - rust
export RUSTUP_HOME=$SCRATCH/.rustup
export CARGO_HOME=$SCRATCH/.cargo

# - python
export WORKON_HOME=$SCRATCH/envs

# CONVENIENCE
alias cz='hx ~/.zshrc'
alias gu='cd $USER_ROOT'
