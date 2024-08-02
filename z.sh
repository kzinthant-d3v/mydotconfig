#!/bin/bash

# Function to print status messages
print_status() {
    echo -e "\033[1;32m$1\033[0m"
}

# Install Zsh
print_status "Installing Zsh..."
sudo apt-get update -y
sudo apt-get install -y zsh

# Get the current user who invoked sudo
CURRENT_USER=$(logname)

# Set Zsh as the default shell for the current user
print_status "Setting Zsh as the default shell for user $CURRENT_USER..."
sudo chsh -s "$(which zsh)" "$CURRENT_USER"

# Confirm installation and configuration
print_status "Zsh installation and configuration complete."
print_status "Please log out and log back in or open a new terminal window to start using Zsh."
