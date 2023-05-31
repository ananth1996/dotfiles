ZSH_DISABLE_COMPFIX=true


source ${HOME}/antigen.zsh
antigen init ${HOME}/.antigenrc

# fzf settings

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
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --multi --info=inline"
export FZF_CTRL_T_OPTS="--preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300' --preview-window='right:60%:wrap' --bind='f2:toggle-preview,alt-w:toggle-preview-wrap,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-y:execute-silent(echo {+} | pbcopy),ctrl-x:execute(rm -i {+})+abort,ctrl-l:clear-query'"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

PATH="/Users/mahadeva/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/mahadeva/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/mahadeva/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/mahadeva/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/mahadeva/perl5"; export PERL_MM_OPT;

# iterm shell integration for ssh stuff
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Activate cargo for rust
source ${HOME}/.cargo/env

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/mahadeva/mambaforge/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/mahadeva/mambaforge/etc/profile.d/conda.sh" ]; then
        . "/Users/mahadeva/mambaforge/etc/profile.d/conda.sh"
    else
        export PATH="/Users/mahadeva/mambaforge/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/Users/mahadeva/mambaforge/etc/profile.d/mamba.sh" ]; then
    . "/Users/mahadeva/mambaforge/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<
eval "$(starship init zsh)"
[[ -f ~/.aliases ]] && source ~/.aliases
eval "$(zoxide init zsh)"

# add the openshift cli 
export PATH="/Users/mahadeva/bin:$PATH"
export PATH="/Users/mahadeva/.local/bin:$PATH"

fpath+=~/.zfunc
autoload -Uz compinit && compinit

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
