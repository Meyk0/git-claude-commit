#!/bin/bash
# Installation script for git-claude-commit

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

# Detect OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     OS_TYPE=Linux;;
    Darwin*)    OS_TYPE=Mac;;
    CYGWIN*)    OS_TYPE=Windows;;
    MINGW*)     OS_TYPE=Windows;;
    MSYS*)      OS_TYPE=Windows;;
    *)          OS_TYPE="UNKNOWN:${OS}"
esac

echo_info "Detected OS: ${OS_TYPE}"

# Check prerequisites
check_prerequisites() {
    echo_info "Checking prerequisites..."
    
    # Check for git
    if ! command -v git &> /dev/null; then
        echo_error "Git is not installed. Please install git first."
        exit 1
    fi
    
    # Check for curl
    if ! command -v curl &> /dev/null; then
        echo_error "curl is not installed. Please install curl first."
        exit 1
    fi
    
    # Check for jq (recommended but not required)
    if ! command -v jq &> /dev/null; then
        echo_warning "jq is not installed. Installing jq is recommended for better config handling."
        if [ "$OS_TYPE" = "Linux" ]; then
            echo "You can install jq with: sudo apt-get install jq (Debian/Ubuntu) or sudo yum install jq (CentOS/RHEL)"
        elif [ "$OS_TYPE" = "Mac" ]; then
            echo "You can install jq with: brew install jq"
        fi
    fi
}

# Directories
INSTALL_DIR="${HOME}/bin"
CONFIG_DIR="${HOME}/.git-claude-commit"

# Create directories
create_directories() {
    echo_info "Creating directories..."
    
    mkdir -p "${INSTALL_DIR}"
    mkdir -p "${CONFIG_DIR}"
    
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
        echo_info "Adding ${INSTALL_DIR} to PATH..."
        
        # Determine shell config file
        SHELL_CONFIG=""
        if [ -f "${HOME}/.bashrc" ]; then
            SHELL_CONFIG="${HOME}/.bashrc"
        elif [ -f "${HOME}/.bash_profile" ]; then
            SHELL_CONFIG="${HOME}/.bash_profile"
        elif [ -f "${HOME}/.zshrc" ]; then
            SHELL_CONFIG="${HOME}/.zshrc"
        fi
        
        if [ -n "${SHELL_CONFIG}" ]; then
            echo 'export PATH="$HOME/bin:$PATH"' >> "${SHELL_CONFIG}"
            echo_success "Added ${INSTALL_DIR} to PATH in ${SHELL_CONFIG}"
            echo_info "You'll need to restart your terminal or run 'source ${SHELL_CONFIG}' for this to take effect."
        else
            echo_warning "Could not find shell config file (.bashrc, .bash_profile, or .zshrc)."
            echo_warning "Please manually add ${INSTALL_DIR} to your PATH."
        fi
    fi
}

# Install script
install_script() {
    echo_info "Installing git-claude-commit..."
    
    # Download or copy the script
    if [ -f "./git-claude-commit" ]; then
        # Local installation
        cp "./git-claude-commit" "${INSTALL_DIR}/git-claude-commit"
    else
        # Download from GitHub
        curl -s -o "${INSTALL_DIR}/git-claude-commit" "https://raw.githubusercontent.com/yourusername/git-claude-commit/main/git-claude-commit"
    fi
    
    # Make executable
    chmod +x "${INSTALL_DIR}/git-claude-commit"
    
    echo_success "git-claude-commit installed to ${INSTALL_DIR}/git-claude-commit"
}

# Configure
configure() {
    echo_info "Setting up configuration..."
    
    # Create default config if it doesn't exist
    CONFIG_FILE="${CONFIG_DIR}/config.json"
    if [ ! -f "${CONFIG_FILE}" ]; then
        cat > "${CONFIG_FILE}" << EOF
{
  "api_key": "",
  "model": "claude-3-7-sonnet-20250219",
  "prompt_template": "I'm about to commit the following code changes. Please generate a concise and informative commit message that summarizes what these changes do. The commit message should follow best practices (50-72 chars for the first line, then a blank line, then more details if needed).\n\nChanges to be committed:\n{diff}",
  "commit_conventions": "conventional commits style with type and scope",
  "max_diff_size": 20000,
  "use_emoji": false,
  "emoji_style": "github",
  "mask_secrets": true
}
EOF
        echo_success "Created default config at ${CONFIG_FILE}"
    else
        echo_info "Config file already exists at ${CONFIG_FILE}"
    fi
    
    # Create history file for storing commit messages
    HISTORY_FILE="${CONFIG_DIR}/history.jsonl"
    if [ ! -f "${HISTORY_FILE}" ]; then
        touch "${HISTORY_FILE}"
        echo_success "Created history file at ${HISTORY_FILE}"
    fi
    
    # Ask for API key
    read -p "Would you like to set your Anthropic API key now? (y/n): " SET_API_KEY
    if [[ "${SET_API_KEY}" =~ ^[Yy]$ ]]; then
        read -p "Enter your Anthropic API key: " API_KEY
        
        if command -v jq &> /dev/null; then
            # Use jq if available
            jq --arg key "${API_KEY}" '.api_key = $key' "${CONFIG_FILE}" > "${CONFIG_FILE}.tmp" && mv "${CONFIG_FILE}.tmp" "${CONFIG_FILE}"
        else
            # Simple sed replacement if jq is not available
            sed -i.bak "s/\"api_key\": \"\"/\"api_key\": \"${API_KEY}\"/" "${CONFIG_FILE}" && rm -f "${CONFIG_FILE}.bak"
        fi
        
        echo_success "API key saved to config file"
    else
        echo_info "You can set your API key later by editing ${CONFIG_FILE}"
        echo_info "Or by running: git claude-commit --configure"
    fi
}

# Add Fish shell support if Fish is installed
if command -v fish >/dev/null 2>&1; then
    echo_info "Detected Fish shell, installing Fish-specific support..."
    mkdir -p "$HOME/.config/fish/functions"
    if [[ -f "./shell/fish/git-claude-commit.fish" ]]; then
        cp "./shell/fish/git-claude-commit.fish" "$HOME/.config/fish/functions/"
        echo_success "Fish shell support installed with command completions"
    else
        echo_warning "Fish shell function file not found. Skipping Fish-specific setup."
    fi
fi

# Main installation process
main() {
    echo "=== git-claude-commit Installer ==="
    echo "This script will install the git-claude-commit extension,"
    echo "which uses Claude AI to generate commit messages for your git commits."
    echo
    
    check_prerequisites
    create_directories
    install_script
    configure
    
    echo
    echo_success "Installation complete!"
    echo "You can now use 'git claude-commit' to generate commit messages with Claude."
    echo
    echo "Usage: git add [files] && git claude-commit"
    echo "For more options: git claude-commit --help"
    echo
    echo "If you encounter any issues, please report them at:"
    echo "https://github.com/yourusername/git-claude-commit/issues"
}

# Run the installer
main