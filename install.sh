#!/bin/bash

#############################################
# DOTFILES INSTALLER - Auto-detect OS
#############################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$(uname -s)" in
    Linux*)
        echo "Detected Linux - running install-linux.sh"
        exec "$SCRIPT_DIR/install-linux.sh" "$@"
        ;;
    Darwin*)
        echo "Detected macOS - running install-mac.sh"
        exec "$SCRIPT_DIR/install-mac.sh" "$@"
        ;;
    *)
        echo "Unknown OS: $(uname -s)"
        exit 1
        ;;
esac
