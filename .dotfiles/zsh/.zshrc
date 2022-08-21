# LOOKS
PROMPT='%F{red}%B(%M)%b%f %F{yellow}%4c %F{14}❯%f '

# RUNTIMES
typeset -TUx LD_LIBRARY_PATH ld_library_path 
path=(
    /opt/homebrew/bin
    $path
)
ld_library_path=(
    $ld_library_path
)

# ENV VARS

# CONVENIENCE
alias tmux='tmux -2 -u'
alias cz='nvim ~/.zshrc'
alias gd='cd ~/Sync/dev'
alias xxx='cd ~/Sync/dev/python/common/schemaeditor2 && pipenv run nvim -S /Users/bas/.local/share/nvim/sessions/schemaeditor.nvim'
