#!/bin/bash
set -e

#############################################
# DOTFILES INSTALLER - Linux
# Designed for GPU instances with Shared File System
# Tools installed to SFS persist across instance changes
#############################################

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Use SFS for persistent tool installations (survives instance changes)
# Change this if your SFS mount point is different
SFS_DIR="/mnt/SFS-Ananth"
LOCAL_BIN="$SFS_DIR/local/bin"
CARGO_HOME="$SFS_DIR/local/cargo"
RUSTUP_HOME="$SFS_DIR/local/rustup"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

#############################################
# PREFLIGHT CHECKS
#############################################

preflight_checks() {
    # Verify we're on Linux
    if [[ "$(uname -s)" != "Linux" ]]; then
        error "This script is for Linux only. Use install-mac.sh for macOS."
        exit 1
    fi
    
    # Verify SFS is mounted
    if [[ ! -d "$SFS_DIR" ]]; then
        error "SFS not found at $SFS_DIR"
        error "Make sure your shared file system is mounted before running this script."
        exit 1
    fi
    
    # Detect distro
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        DISTRO="$ID"
    fi
    
    info "Detected: Linux ${DISTRO:+($DISTRO)}"
    info "SFS: $SFS_DIR"
}

#############################################
# SYSTEM PACKAGES
#############################################

install_system_packages() {
    info "Checking system packages..."
    
    local packages=(
        build-essential
        curl
        git
        wget
        unzip
        pkg-config
        libssl-dev
    )
    
    if command -v sudo &> /dev/null && sudo -n true 2>/dev/null; then
        sudo apt-get update -qq
        sudo apt-get install -y -qq "${packages[@]}"
        success "System packages installed"
    else
        warn "No sudo access - skipping system packages"
        warn "You may need to install: ${packages[*]}"
    fi
}

#############################################
# DIRECTORY SETUP
#############################################

setup_directories() {
    info "Setting up directories..."
    
    mkdir -p "$LOCAL_BIN"
    mkdir -p "$CARGO_HOME"
    mkdir -p "$RUSTUP_HOME"
    mkdir -p "$HOME/.config"
    
    success "Directories created"
}

#############################################
# FZF
#############################################

install_fzf() {
    if [[ -f "$HOME/.fzf/bin/fzf" ]]; then
        success "fzf already installed"
        return
    fi
    
    info "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    yes | "$HOME/.fzf/install" --no-update-rc
    success "fzf installed"
}

#############################################
# RUST & CARGO TOOLS
#############################################

install_rust() {
    export CARGO_HOME="$CARGO_HOME"
    export RUSTUP_HOME="$RUSTUP_HOME"
    
    if [[ -f "$CARGO_HOME/bin/rustc" ]]; then
        success "Rust already installed"
        return
    fi
    
    info "Installing Rust to SFS..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    success "Rust installed"
}

install_cargo_tools() {
    export CARGO_HOME="$CARGO_HOME"
    export RUSTUP_HOME="$RUSTUP_HOME"
    export PATH="$CARGO_HOME/bin:$PATH"
    
    local crates=(
        bat           # Better cat with syntax highlighting
        fd-find       # Better find
        ripgrep       # Better grep
        eza           # Better ls (fork of exa)
        du-dust       # Better du (disk usage)
        git-delta     # Better git diff
        starship      # Cross-shell prompt
        zoxide        # Smarter cd
        hyperfine     # Benchmarking tool
    )
    
    info "Installing Cargo tools to SFS..."
    for crate in "${crates[@]}"; do
        if [[ -f "$CARGO_HOME/bin/${crate%%-*}" ]] || [[ -f "$CARGO_HOME/bin/$crate" ]]; then
            success "$crate already installed"
        else
            info "Installing $crate..."
            "$CARGO_HOME/bin/cargo" install "$crate" --quiet
            success "$crate installed"
        fi
    done
}

#############################################
# DIRENV
#############################################

install_direnv() {
    local direnv_bin="$LOCAL_BIN/direnv"
    
    if [[ -f "$direnv_bin" ]]; then
        success "direnv already installed"
        return
    fi
    
    info "Installing direnv to SFS..."
    
    local arch
    case "$(uname -m)" in
        x86_64)  arch="amd64" ;;
        aarch64) arch="arm64" ;;
        *)       error "Unsupported architecture for direnv"; return 1 ;;
    esac
    
    curl -sfL "https://github.com/direnv/direnv/releases/latest/download/direnv.linux-${arch}" -o "$direnv_bin"
    chmod +x "$direnv_bin"
    success "direnv installed"
}

#############################################
# SYMLINK DOTFILES
#############################################

link_dotfiles() {
    info "Linking dotfiles..."
    
    local files=(
        "config/bashrc:$HOME/.bashrc_dotfiles"
        "config/aliases:$HOME/.aliases"
        "config/gitconfig:$HOME/.gitconfig_dotfiles"
    )
    
    for mapping in "${files[@]}"; do
        local src="${DOTFILES_DIR}/${mapping%%:*}"
        local dst="${mapping##*:}"
        
        if [[ -f "$src" ]]; then
            mkdir -p "$(dirname "$dst")"
            ln -sf "$src" "$dst"
            success "Linked $dst"
        fi
    done
    
    # Source our config from bashrc
    local shell_rc="$HOME/.bashrc"
    local source_line="[ -f ~/.bashrc_dotfiles ] && source ~/.bashrc_dotfiles"
    
    if ! grep -qF "bashrc_dotfiles" "$shell_rc" 2>/dev/null; then
        echo "" >> "$shell_rc"
        echo "# Dotfiles configuration" >> "$shell_rc"
        echo "$source_line" >> "$shell_rc"
        success "Added source line to $shell_rc"
    fi
}

#############################################
# MAIN
#############################################

main() {
    echo ""
    echo "=========================================="
    echo "  Dotfiles Installer (Linux/SFS)"
    echo "=========================================="
    echo ""
    
    preflight_checks
    setup_directories
    install_system_packages
    install_fzf
    install_rust
    install_cargo_tools
    install_direnv
    link_dotfiles
    
    echo ""
    success "Installation complete!"
    echo ""
    info "Tools installed to: $SFS_DIR/local/"
    info "To apply changes, run: source ~/.bashrc"
    echo ""
}

main "$@"
