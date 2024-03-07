#!/bin/bash



##############
# FZF
##############

if [[ ! -f $HOME/.fzf/bin/fzf ]]; then
    git clone https://github.com/junegunn/fzf.git $HOME/.fzf
    yes | $HOME/.fzf/install
fi

###############
# RUST
##############

if [[ ! -d $HOME/.rustup ]]; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

for crate in bat fd-find ripgrep eza du-dust ripgrep git-delta starship zoxide hyperfine
do
    $HOME/.cargo/bin/cargo install $crate
done
