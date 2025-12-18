#!/usr/bin/env bash
set -e

# Git-Stalk Installation Script
# This script installs git-stalk and its dependencies

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root for system-wide installation
check_permissions() {
    if [[ "$1" == "--system" ]] && [[ $EUID -ne 0 ]]; then
        print_error "System-wide installation requires root privileges. Please run with sudo."
        exit 1
    fi
}

# Detect package manager and install dependencies
install_dependencies() {
    print_status "Installing dependencies (curl and jq)..."
    
    if command -v apt-get &> /dev/null; then
        # Ubuntu/Debian
        print_status "Detected Debian/Ubuntu system..."
        sudo apt-get update
        sudo apt-get install -y curl jq
    elif command -v dnf &> /dev/null; then
        # Fedora
        print_status "Detected Fedora system..."
        sudo dnf install -y curl jq
    elif command -v yum &> /dev/null; then
        # CentOS/RHEL
        print_status "Detected CentOS/RHEL system..."
        sudo yum install -y curl jq
    elif command -v brew &> /dev/null; then
        # macOS
        print_status "Detected macOS system..."
        brew install curl jq
    elif command -v pacman &> /dev/null; then
        # Arch Linux
        print_status "Detected Arch Linux system..."
        sudo pacman -S --noconfirm curl jq
    elif command -v apk &> /dev/null; then
        # Alpine Linux
        print_status "Detected Alpine Linux system..."
        sudo apk add curl jq
    elif command -v zypper &> /dev/null; then
        # openSUSE
        print_status "Detected openSUSE system..."
        sudo zypper install -y curl jq
    else
        print_warning "Could not detect package manager. Please install curl and jq manually:"
        echo "  - curl: https://curl.se/download.html"
        echo "  - jq: https://stedolan.github.io/jq/download/"
        echo ""
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Verify dependencies are installed
verify_dependencies() {
    print_status "Verifying dependencies..."
    
    if ! command -v curl &> /dev/null; then
        print_error "curl is not installed or not in PATH"
        exit 1
    fi
    
    if ! command -v jq &> /dev/null; then
        print_error "jq is not installed or not in PATH"
        exit 1
    fi
    
    print_success "Dependencies verified!"
}

# Download git-stalk script
download_script() {
    local install_dir="$1"
    local script_path="$install_dir/git-stalk"
    
    print_status "Downloading git-stalk script..."
    
    # Create install directory if it doesn't exist
    mkdir -p "$install_dir"
    
    # Download the script
    if command -v curl &> /dev/null; then
        curl -fsSL https://raw.githubusercontent.com/dim-ghub/Git-Stalk/main/git-stalk -o "$script_path"
    elif command -v wget &> /dev/null; then
        wget -q https://raw.githubusercontent.com/dim-ghub/Git-Stalk/main/git-stalk -O "$script_path"
    else
        print_error "Neither curl nor wget is available. Please install one of them and try again."
        exit 1
    fi
    
    # Make it executable
    chmod +x "$script_path"
    
    print_success "git-stalk installed to $script_path"
}

# Update PATH if necessary
update_path() {
    local install_dir="$1"
    
    if [[ ":$PATH:" != *":$install_dir:"* ]]; then
        print_warning "$install_dir is not in your PATH"
        echo "To add it to your PATH, add the following line to your shell profile:"
        echo ""
        echo "  export PATH=\"\$PATH:$install_dir\""
        echo ""
        echo "For bash, add to ~/.bashrc or ~/.bash_profile"
        echo "For zsh, add to ~/.zshrc"
        echo "For fish, add to ~/.config/fish/config.fish"
    fi
}

# Show usage information
show_usage() {
    echo ""
    print_success "Installation completed! 🎉"
    echo ""
    echo "Usage:"
    echo "  git-stalk -u <username>          # Get commits from GitHub user"
    echo "  git-stalk -g -u <username>       # Get commits from GitLab user"
    echo "  git-stalk -h                     # Show help"
    echo ""
    echo "For more examples and options, run: git-stalk --help"
    echo ""
    echo "Configuration:"
    echo "  You can set default tokens in the script at:"
    echo "  $(which git-stalk 2>/dev/null || echo "$HOME/.local/bin/git-stalk")"
    echo ""
}

# Parse command line arguments
INSTALL_DIR="$HOME/.local/bin"
SYSTEM_INSTALL=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --system)
            INSTALL_DIR="/usr/local/bin"
            SYSTEM_INSTALL=true
            shift
            ;;
        --dir)
            INSTALL_DIR="$2"
            shift 2
            ;;
        --help|-h)
            echo "Git-Stalk Installation Script"
            echo ""
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --system         Install system-wide to /usr/local/bin (requires sudo)"
            echo "  --dir <path>     Install to custom directory (default: ~/.local/bin)"
            echo "  --help, -h       Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                # Install to ~/.local/bin (user installation)"
            echo "  $0 --system       # Install system-wide (requires sudo)"
            echo "  $0 --dir ~/bin    # Install to ~/bin"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use --help for usage information."
            exit 1
            ;;
    esac
done

# Main installation process
main() {
    echo "Git-Stalk Installation Script"
    echo "============================="
    echo ""
    
    check_permissions "$1"
    install_dependencies
    verify_dependencies
    download_script "$INSTALL_DIR"
    
    if [[ "$SYSTEM_INSTALL" == false ]]; then
        update_path "$INSTALL_DIR"
    fi
    
    show_usage
}

# Run main function
main "$@"