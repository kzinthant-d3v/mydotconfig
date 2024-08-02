#!/bin/bash


# Script to install Node.js, pnpm, fzf, ripgrep, and cmake with checks for existing installations


# Update package list

echo "Updating package lists..."

sudo apt-get update


# Install build-essential for compilation needs

echo "Installing build-essential for compilation..."

sudo apt-get install -y build-essential


# Function to check if a command exists

command_exists() {

  command -v "$1" >/dev/null 2>&1

}


# Install Node.js if not already installed

if command_exists node; then

  echo "Node.js is already installed. Skipping installation."

else

  echo "Installing Node.js..."

  curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -

  sudo apt-get install -y nodejs

fi


# Install pnpm if not already installed

if command_exists pnpm; then

  echo "pnpm is already installed. Skipping installation."

else

  echo "Installing pnpm..."

  curl -fsSL https://get.pnpm.io/install.sh | bash -


  # Ensure pnpm is added to the PATH

  export PNPM_HOME="$HOME/.local/share/pnpm"

  export PATH="$PNPM_HOME:$PATH"


  # Persist pnpm to PATH

  if ! grep -q "export PATH=\"$PNPM_HOME:\$PATH\"" ~/.bashrc; then

    echo 'export PATH="$PNPM_HOME:$PATH"' >> ~/.bashrc

  fi

fi


# Install fzf if not already installed

if command_exists fzf; then

  echo "fzf is already installed. Skipping installation."

else

  echo "Installing fzf..."

  sudo apt-get install -y fzf

fi


# Install ripgrep if not already installed

if command_exists rg; then

  echo "ripgrep is already installed. Skipping installation."

else

  echo "Installing ripgrep..."

  sudo apt-get install -y ripgrep

fi


# Install cmake if not already installed

if command_exists cmake; then

  echo "cmake is already installed. Skipping installation."

else

  echo "Installing cmake..."

  sudo apt-get install -y cmake

fi


# Refresh shell

echo "Refreshing shell environment..."

source ~/.bashrc


# Verify installations

echo "Checking installed versions:"

echo "Node.js version: $(node -v)"

echo "pnpm version: $(pnpm -v)"

echo "fzf version: $(fzf --version)"

echo "ripgrep version: $(rg --version)"

echo "cmake version: $(cmake --version)"


echo "Installation complete. Node.js, pnpm, fzf, ripgrep, and cmake are ready to use."

