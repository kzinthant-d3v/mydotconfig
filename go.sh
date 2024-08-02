#!/bin/bash

# Define variables
GO_VERSION="1.20.7"  # Specify the latest Go version here
GO_TAR="go$GO_VERSION.linux-amd64.tar.gz"
GO_URL="https://golang.org/dl/$GO_TAR"
GO_INSTALL_DIR="/usr/local/go"
SUDO_USER_HOME=$(eval echo ~${SUDO_USER})


# Function to print status messages
print_status() {
    echo -e "\033[1;32m$1\033[0m"
}

# Install dependencies
print_status "Installing dependencies..."
sudo apt-get update -y
sudo apt-get install -y curl

# Remove any previous Go installation
print_status "Removing any previous Go installation..."
sudo rm -rf "$GO_INSTALL_DIR"

# Download and install Go
print_status "Downloading Go $GO_VERSION..."
curl -LO "$GO_URL"

print_status "Installing Go..."
sudo tar -C /usr/local -xzf "$GO_TAR"
rm -f "$GO_TAR"

# Set up Go environment in .zshrc
if ! grep -q "export GOPATH=" "$SUDO_USER_HOME/.zshrc"; then
    print_status "Adding Go environment variables to .zshrc..."
    echo "export GOPATH=\$HOME/go" >> "$SUDO_USER_HOME/.zshrc"
    echo "export PATH=\$PATH:/usr/local/go/bin:\$GOPATH/bin" >> "$SUDO_USER_HOME/.zshrc"
fi

# Source .zshrc to apply changes
print_status "Sourcing .zshrc to apply changes..."
sudo -u "$SUDO_USER" bash -c "source $SUDO_USER_HOME/.zshrc"

print_status "Go installation and configuration complete. Open a new terminal or log out and log back in."
