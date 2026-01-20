#!/bin/bash

#############################################
# DOTFILES INSTALLER - macOS
# Simple install to $HOME (original setup)
#############################################

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }

#############################################
# FZF
#############################################

if [[ ! -f $HOME/.fzf/bin/fzf ]]; then
    info "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
    yes | $HOME/.fzf/install
    success "fzf installed"
else
    success "fzf already installed"
fi

#############################################
# RUST & CARGO TOOLS
#############################################

if [[ ! -d $HOME/.rustup ]]; then
    info "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    success "Rust installed"
else
    success "Rust already installed"
fi

source "$HOME/.cargo/env"

info "Installing Cargo tools..."
for crate in bat fd-find ripgrep eza du-dust git-delta starship zoxide hyperfine
do
    if [[ -f "$HOME/.cargo/bin/${crate%%-*}" ]] || [[ -f "$HOME/.cargo/bin/$crate" ]]; then
        success "$crate already installed"
    else
        info "Installing $crate..."
        cargo install "$crate" --quiet
        success "$crate installed"
    fi
done

echo ""
success "Installation complete!"
info "Restart your shell or run: source ~/.zshrc"
