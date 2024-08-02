#!/bin/bash


# Script to install the latest version of lazygit


# Function to check if a command exists

command_exists() {

  command -v "$1" >/dev/null 2>&1

}


# Check if lazygit is already installed

if command_exists lazygit; then

  echo "lazygit is already installed. Skipping installation."

  echo "Current lazygit version: $(lazygit --version)"

  exit 0

fi


# Install dependencies if not present

echo "Installing dependencies..."

sudo apt-get update

sudo apt-get install -y curl tar


# Fetch the latest lazygit release version

echo "Fetching the latest release of lazygit..."

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')


# Download the latest release of lazygit

echo "Downloading lazygit version ${LAZYGIT_VERSION}..."

curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"


# Extract lazygit binary

echo "Extracting lazygit..."

tar xf lazygit.tar.gz lazygit


# Install the binary to /usr/local/bin

echo "Installing lazygit..."

sudo install lazygit /usr/local/bin


# Clean up

echo "Cleaning up..."

rm lazygit.tar.gz

rm lazygit


# Verify installation

if command_exists lazygit; then

  echo "lazygit successfully installed."

  lazygit --version

else

  echo "lazygit installation failed."

  exit 1

fi
