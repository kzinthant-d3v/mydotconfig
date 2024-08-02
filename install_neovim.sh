#!/bin/bash

# Script to download and install the latest Neovim binary for Linux

# Variables
NEOVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
INSTALL_DIR="/opt/nvim"

# Determine which profile file to use based on existing files
if [ -f "$HOME/.bashrc" ]; then
	  PROFILE_FILE="$HOME/.bashrc"
  elif [ -f "$HOME/.zshrc" ]; then
	    PROFILE_FILE="$HOME/.zshrc"
    else
	      echo "Neither .bashrc nor .zshrc found. Please create one of these files and rerun the script."
	        exit 1
fi

# Download the latest Neovim binary
echo "Downloading Neovim..."
curl -LO "$NEOVIM_URL"

# Remove any existing Neovim installation in the target directory
echo "Removing any existing Neovim installation at $INSTALL_DIR..."
sudo rm -rf "$INSTALL_DIR"

# Extract the downloaded archive to /opt
echo "Extracting Neovim to $INSTALL_DIR..."
sudo tar -C /opt -xzf nvim-linux64.tar.gz

# Remove the downloaded archive
rm nvim-linux64.tar.gz

# Update PATH in the user's shell configuration file if not already present
if ! grep -q "/opt/nvim-linux64/bin" "$PROFILE_FILE"; then
	  echo "Updating PATH in $PROFILE_FILE..."
	    echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> "$PROFILE_FILE"
	      
	      # Source the profile file to apply changes
	        echo "Sourcing $PROFILE_FILE to apply changes..."
		  source "$PROFILE_FILE"
	  else
		    echo "PATH is already updated in $PROFILE_FILE."
fi

# Verify if nvim command is available
if command -v nvim > /dev/null; then
	  echo "Neovim installation complete and accessible via 'nvim' command!"
  else
	    echo "Neovim installation complete, but 'nvim' command is not found in PATH. Try restarting your terminal."
fi

