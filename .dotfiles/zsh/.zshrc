# LOOKS
PROMPT='%F{red}%B(%M)%b%f %F{yellow}%4c %F{cyan}❯%f '

# RUNTIMES
typeset -TUx LD_LIBRARY_PATH ld_library_path 
path=(
    $path
)
ld_library_path=(
    $ld_library_path
)

# ENV VARS

# CONVENIENCE
alias tmux='tmux -2 -u'
alias cz='nvim ~/.zshrc'