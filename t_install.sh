#!/bin/bash


# Script to install tmux and set up tpm (tmux plugin manager)


# Function to check if a command exists


clone_tpm_plugins() {

echo "Setting up tmux plugin manager (tpm)..."

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then

  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

  echo "tpm successfully cloned."

else

  echo "tpm is already installed. Skipping cloning."

fi
}

command_exists() {

  command -v "$1" >/dev/null 2>&1

}


# Check if tmux is already installed

if command_exists tmux; then

  echo "tmux is already installed. Skipping installation."

  echo "Current tmux version: $(tmux -V)"

  clone_tpm_plugins

else

  # Install tmux using the package manager

  echo "Installing tmux using the package manager..."

  sudo apt-get update

  sudo apt-get install -y tmux


  # Verify installation

  if command_exists tmux; then

    echo "tmux successfully installed."

    tmux -V

  else

    echo "Installing dependencies for building tmux..."

    sudo apt-get install -y build-essential automake bison pkg-config libevent-dev libncurses5-dev xclip


    # Fetch the latest tmux release version

    echo "Fetching the latest release of tmux..."

    TMUX_VERSION=$(curl -s https://api.github.com/repos/tmux/tmux/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')


    # Download and extract tmux

    echo "Downloading tmux version ${TMUX_VERSION}..."

    curl -Lo tmux.tar.gz "https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz"

    tar xf tmux.tar.gz


    # Build and install tmux

    cd tmux-${TMUX_VERSION}

    ./configure

    make

    sudo make install



    cd ..

    rm -rf tmux-${TMUX_VERSION} tmux.tar.gz



    if command_exists tmux; then

      echo "tmux successfully installed."

      tmux -V

      clone_tpm_plugins

    else

      echo "tmux installation failed."

      exit 1

    fi

  fi

fi
