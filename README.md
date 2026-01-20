# Dotfiles

Cross-platform dotfiles designed for **GPU instances** with a **Shared File System (SFS)**.

## Quick Start

```bash
cd /mnt/SFS-Ananth/dotfiles
./install.sh
source ~/.bashrc
```

## Features

- **OS Detection**: Works on macOS and Linux (Ubuntu/Debian)
- **SFS-Aware**: Installs tools to `/mnt/SFS-Ananth/local/` so they persist across instance changes
- **Idempotent**: Safe to run multiple times; skips already-installed tools
- **Modern CLI Tools**: Replaces common utilities with faster, better alternatives

## What Gets Installed

### CLI Tools (via Cargo)

| Tool | Replaces | Description |
|------|----------|-------------|
| `bat` | `cat` | Syntax highlighting, line numbers |
| `eza` | `ls` | Icons, git integration |
| `fd` | `find` | Faster, intuitive syntax |
| `ripgrep` | `grep` | Much faster, respects .gitignore |
| `dust` | `du` | Visual disk usage |
| `delta` | `diff` | Beautiful git diffs |
| `starship` | bash prompt | Cross-shell, customizable |
| `zoxide` | `cd` | Learns your habits |
| `hyperfine` | `time` | Benchmarking tool |
| `fzf` | - | Fuzzy finder |

### Configuration Files

- `~/.bashrc_dotfiles` - Shell configuration (PATH, tool init)
- `~/.aliases` - Modern command aliases
- `~/.config/starship.toml` - Prompt configuration
- `~/.gitconfig_dotfiles` - Git aliases and delta integration

## Directory Structure

```
dotfiles/
├── install.sh              # Main installer
├── config/
│   ├── bashrc              # Shell configuration
│   ├── aliases             # Command aliases
│   ├── starship.toml       # Prompt config
│   └── gitconfig           # Git config
└── README.md
```

## SFS Installation Paths

Tools are installed to the SFS so they survive instance changes:

```
/mnt/SFS-Ananth/local/
├── bin/                    # Custom binaries
├── cargo/                  # Cargo home (Rust packages)
└── rustup/                 # Rust toolchain
```

## New Instance Setup

When you spin up a new GPU instance:

1. **First time only** - Run the full installer:
   ```bash
   cd /mnt/SFS-Ananth/dotfiles
   ./install.sh
   ```

2. **Subsequent instances** - Tools are already on SFS, just link configs:
   ```bash
   cd /mnt/SFS-Ananth/dotfiles
   ./install.sh  # Fast - skips installed tools
   source ~/.bashrc
   ```

## GPU-Specific Aliases

```bash
gpus          # nvidia-smi
gpu-watch     # watch nvidia-smi (updates every second)
```

## Customization

### Local Overrides

Create `~/.bashrc_local` for machine-specific settings (not tracked in git):

```bash
# ~/.bashrc_local
export MY_API_KEY="..."
alias myproject="cd /path/to/project"
```

### Modify SFS Path

If your SFS is mounted elsewhere, update these variables in:
- `install.sh`: `SFS_DIR`
- `config/bashrc`: `SFS_DIR`

## Useful Aliases

```bash
# Modern replacements (automatic)
cat file.txt      # Uses bat
ls                # Uses eza with icons
grep pattern      # Uses ripgrep
find -name "*.py" # Uses fd

# Navigation
sfs               # cd to /mnt/SFS-Ananth
..                # cd ..
...               # cd ../..

# Git shortcuts
gs                # git status
ga                # git add
gc                # git commit
gp                # git push
gl                # git pull
glog              # Pretty git log

# FZF enhanced
fe                # Fuzzy find and edit file
fcd               # Fuzzy cd to recent directory
fgl               # Fuzzy git log
```

## Troubleshooting

### Commands not found after install
```bash
source ~/.bashrc
# or start a new terminal
```

### No sudo access
The installer will skip system packages. You may need to ask your admin to install:
- `build-essential`, `curl`, `git`, `pkg-config`, `libssl-dev`

### Starship prompt not showing
Ensure your terminal supports Unicode and has a [Nerd Font](https://www.nerdfonts.com/) installed.
