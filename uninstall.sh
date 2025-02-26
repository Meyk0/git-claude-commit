#!/bin/bash
# Uninstallation script for git-claude-commit

set -e

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Echo with color
echo_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

echo_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

echo_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

echo_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Directories
INSTALL_DIR="${HOME}/bin"
CONFIG_DIR="${HOME}/.git-claude-commit"
SCRIPT_PATH="${INSTALL_DIR}/git-claude-commit"

# Remove script
remove_script() {
    echo_info "Removing git-claude-commit script..."
    
    if [ -f "${SCRIPT_PATH}" ]; then
        rm "${SCRIPT_PATH}"
        echo_success "Removed ${SCRIPT_PATH}"
    else
        echo_warning "Script not found at ${SCRIPT_PATH}"
    fi
}

# Remove configuration
remove_config() {
    echo_info "Checking for configuration directory..."
    
    if [ -d "${CONFIG_DIR}" ]; then
        read -p "Would you like to remove the configuration directory (${CONFIG_DIR})? This will delete your API key and history. (y/n): " REMOVE_CONFIG
        
        if [[ "${REMOVE_CONFIG}" =~ ^[Yy]$ ]]; then
            rm -rf "${CONFIG_DIR}"
            echo_success "Removed configuration directory: ${CONFIG_DIR}"
        else
            echo_info "Keeping configuration directory: ${CONFIG_DIR}"
        fi
    else
        echo_info "No configuration directory found at ${CONFIG_DIR}"
    fi
}

# Main uninstallation process
main() {
    echo "=== git-claude-commit Uninstaller ==="
    echo "This script will uninstall the git-claude-commit extension."
    echo
    
    remove_script
    remove_config
    
    echo
    echo_success "Uninstallation complete!"
    echo_info "If you added ~/bin to your PATH for this tool, you may want to remove that line from your shell configuration file."
    echo
}

# Run the uninstaller
main