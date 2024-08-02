#!/bin/bash

# Define variables
NVIM_DIR="/usr/local/nvim"
NVIM_BIN_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
NVIM_TAR="nvim-linux64.tar.gz"
NVIM_BIN_DIR="$NVIM_DIR/bin"
SUDO_USER_HOME=$(eval echo ~${SUDO_USER})

# Function to print status messages
print_status() {
    echo -e "\033[1;32m$1\033[0m"
}

# Install dependencies
print_status "Installing dependencies..."
sudo apt-get update -y
sudo apt-get install -y curl tar

# Download and extract Neovim
print_status "Downloading Neovim..."
curl -LO "$NVIM_BIN_URL"

print_status "Installing Neovim..."
sudo mkdir -p "$NVIM_DIR"
sudo tar xzf "$NVIM_TAR" -C "$NVIM_DIR" --strip-components=1
rm -f "$NVIM_TAR"

# Ensure /usr/local/bin is in PATH and link nvim
sudo ln -sfn "$NVIM_BIN_DIR/nvim" /usr/local/bin/nvim

# Add Neovim to PATH in .zshrc
if ! grep -q "$NVIM_BIN_DIR" "$SUDO_USER_HOME/.zshrc"; then
    print_status "Adding Neovim to PATH in .zshrc..."
    echo "export PATH=\"\$PATH:$NVIM_BIN_DIR\"" >> "$SUDO_USER_HOME/.zshrc"
    echo "alias vim='nvim'" >> "$SUDO_USER_HOME/.zshrc"
fi

# Source .zshrc to apply changes
print_status "Sourcing .zshrc to apply changes..."
sudo -u "$SUDO_USER" bash -c "source $SUDO_USER_HOME/.zshrc"

print_status "Neovim installation and configuration complete."
