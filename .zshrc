# zmodload zsh/zprof
ZSH_DISABLE_COMPFIX=true

fpath+=~/.zfunc
autoload -Uz compinit && compinit
# Mac Key Binding 
[[ -f ~/.mac_key_bindings ]] && source ~/.mac_key_bindings

[[ -e ${ZDOTDIR:-~}/.antidote ]] ||
  git clone https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
#source ${ZDOTDIR:-~}/.antidote/antidote.zsh
# antidote load
zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins.zsh

# Ensure you have a .zsh_plugins.txt file where you can add plugins.
[[ -f ${zsh_plugins:r}.txt ]] || touch ${zsh_plugins:r}.txt

# Lazy-load antidote.
fpath+=(${ZDOTDIR:-~}/.antidote)
autoload -Uz $fpath[-1]/antidote

# Generate static file in a subshell when .zsh_plugins.txt is updated.
if [[ ! $zsh_plugins -nt ${zsh_plugins:r}.txt ]]; then
  (antidote bundle <${zsh_plugins:r}.txt >|$zsh_plugins)
fi

# Source your static plugins file.
source $zsh_plugins
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

# export STARSHIP_LOG=trace starship timings
eval "$(starship init zsh)"

[[ -f ~/.aliases ]] && source ~/.aliases
eval "$(zoxide init zsh)"

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# If using kitty terminal then ensure that ssh works correctly
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

# jump words more effectively
# https://apple.stackexchange.com/questions/463712/is-there-a-way-to-jump-within-a-word-using-option-with-arrow-keys-in-iterm2
export WORDCHARS='*_-.[]~;!$%^(){}<>'
autoload -Uz select-word-style
select-word-style normal
# zprof
