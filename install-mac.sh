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

# crate:binary - the binary name often differs from the crate name, so we
# can't derive one from the other.
info "Installing Cargo tools..."
for entry in bat:bat fd-find:fd ripgrep:rg eza:eza du-dust:dust git-delta:delta starship:starship zoxide:zoxide hyperfine:hyperfine
do
    crate="${entry%%:*}"
    binary="${entry##*:}"

    if [[ -f "$HOME/.cargo/bin/$binary" ]]; then
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
