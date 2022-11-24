# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# proxies for Turso login node
export https_proxy=http://www-cache.cs.helsinki.fi:3128
export http_proxy=http://www-cache.cs.helsinki.fi:3128
export HTTP_PROXY=http://www-cache.cs.helsinki.fi:3128
export HTTPS_PROXY=http://www-cache.cs.helsinki.fi:3128

export MPLCONFIGDIR=/wrk/users/mahadeva/.config
# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# Setting for the new UTF-8 terminal support in Lion
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/proj/mahadeva/mambaforge/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/proj/mahadeva/mambaforge/etc/profile.d/conda.sh" ]; then
        . "/proj/mahadeva/mambaforge/etc/profile.d/conda.sh"
    else
        export PATH="/proj/mahadeva/mambaforge/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/proj/mahadeva/mambaforge/etc/profile.d/mamba.sh" ]; then
    . "/proj/mahadeva/mambaforge/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

# load rust
. "/proj/mahadeva/.cargo/env"
# rust variables
export RUSTUP_HOME=$PROJ/.rustup
export CARGO_HOME=$PROJ/.cargo
source /proj/mahadeva/.cargo/env

# fzf settings
export FD_OPTIONS="--exclude .jupyterhub-tree --exclude .vscode-server --exclude .git"

# # Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}
export FZF_DEFAULT_COMMAND="fd --type f ${FD_OPTIONS}"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d ${FD_OPTIONS}"
export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --multi --info=inline"
export FZF_CTRL_T_OPTS="--preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300' --preview-window='right:60%:wrap' --bind='f2:toggle-preview,alt-w:toggle-preview-wrap,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-y:execute-silent(echo {+} | pbcopy),ctrl-x:execute(rm -i {+})+abort,ctrl-l:clear-query'"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
# append and reload the history after each command
PROMPT_COMMAND="history -a; history -n"

# ignore certain commands from the history
HISTIGNORE="ls:ll:cd:pwd:bg:fg:history"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=10000000

# Adds starship prompt
eval "$(starship init bash)"
# source aliases 
[ -f ~/.aliases ] && source ~/.aliases
eval "$(zoxide init bash)"
