#!/bin/bash

# Script to install the latest version of Go (Golang)

# Define the directory where Go will be installed
INSTALL_DIR="/usr/local"

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if Go is already installed
if command_exists go; then
  echo "Go is already installed. Skipping installation."
  echo "Current Go version: $(go version)"
  exit 0
fi

# Fetch the latest stable Go version from the Go downloads page
echo "Fetching the latest Go version..."
GO_VERSION=$(curl -s https://go.dev/dl/ | grep -oP 'go[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)

# Construct the download URL
DOWNLOAD_URL="https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz"

# Verify if the URL is reachable
if ! curl --output /dev/null --silent --head --fail "$DOWNLOAD_URL"; then
  echo "Error: The Go download URL is not reachable: $DOWNLOAD_URL"
  exit 1
fi

# Download the latest Go binary
echo "Downloading Go ${GO_VERSION}..."
wget "$DOWNLOAD_URL" -O /tmp/go.tar.gz

# Remove any previous Go installation and extract the new one
echo "Removing any previous Go installation..."
sudo rm -rf "${INSTALL_DIR}/go"

echo "Extracting Go ${GO_VERSION} to ${INSTALL_DIR}..."
sudo tar -C "${INSTALL_DIR}" -xzf /tmp/go.tar.gz

# Clean up the downloaded archive
rm /tmp/go.tar.gz

# Set up Go environment variables in the current shell session
export PATH="$PATH:/usr/local/go/bin"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# Persist Go environment variables
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc

# Source .bashrc to apply changes in the current terminal session
source ~/.bashrc

# Verify the installation
echo "Verifying Go installation..."
go version

echo "Go installation complete. You may need to restart your terminal."


