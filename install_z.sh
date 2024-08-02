#!/bin/bash


# Script to install Zsh, Oh My Zsh, and configure Powerlevel10k


# Function to install a package if it is not already installed

install_if_not_present() {

  PACKAGE_NAME=$1

  if ! dpkg -s $PACKAGE_NAME >/dev/null 2>&1; then

    echo "Installing $PACKAGE_NAME..."

    sudo apt-get install -y $PACKAGE_NAME

  else

    echo "$PACKAGE_NAME is already installed."

  fi

}


# Update package list

echo "Updating package lists..."

sudo apt-get update


# Install Zsh

install_if_not_present zsh


# Install Git (required for Oh My Zsh)

install_if_not_present git


# Install wget (used for downloading scripts)

install_if_not_present wget


# Install curl (used for downloading scripts)

install_if_not_present curl


# Install fonts

install_if_not_present fonts-powerline


# Install Zsh as the default shell without prompt

if [ "$(echo $SHELL)" != "$(which zsh)" ]; then

  echo "Changing default shell to Zsh for user $USER..."

  sudo chsh -s "$(which zsh)" "$USER"

else

  echo "Zsh is already the default shell."

fi


# Install Oh My Zsh

if [ ! -d "$HOME/.oh-my-zsh" ]; then

  echo "Installing Oh My Zsh..."

  RUNZSH=no sh -c "$(curl -fsSL 
  https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

else

  echo "Oh My Zsh is already installed."

fi


# Install Powerlevel10k

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then

  echo "Installing Powerlevel10k theme..."

  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git 
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

else

  echo "Powerlevel10k is already installed."

fi


# Set Powerlevel10k theme in .zshrc

if ! grep -q "ZSH_THEME=\"powerlevel10k/powerlevel10k\"" "$HOME/.zshrc"; then

  echo "Configuring Powerlevel10k theme in .zshrc..."

  sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc"

fi


# Download and install Powerlevel10k configuration file

P10K_CONFIG_URL="https://raw.githubusercontent.com/romkatv/powerlevel10k/master/config/p10k-classic.zsh"

P10K_CONFIG_FILE="$HOME/.p10k.zsh"


if [ ! -f "$P10K_CONFIG_FILE" ]; then

  echo "Downloading Powerlevel10k configuration..."

  wget -O "$P10K_CONFIG_FILE" "$P10K_CONFIG_URL"

else

  echo "Powerlevel10k configuration is already set up."

fi


# Add source command to .zshrc for Powerlevel10k configuration

if ! grep -q "source $HOME/.p10k.zsh" "$HOME/.zshrc"; then

  echo "Adding Powerlevel10k configuration source to .zshrc..."

  echo "source $HOME/.p10k.zsh" >> "$HOME/.zshrc"

fi


# Install recommended fonts for Powerlevel10k

FONTS_DIR="$HOME/.local/share/fonts"

mkdir -p "$FONTS_DIR"


echo "Installing recommended fonts for Powerlevel10k..."

curl -L -o "$FONTS_DIR/MesloLGS\ NF\ Regular.ttf" 
"https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"

curl -L -o "$FONTS_DIR/MesloLGS\ NF\ Bold.ttf" 
"https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"

curl -L -o "$FONTS_DIR/MesloLGS\ NF\ Italic.ttf" 
"https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"

curl -L -o "$FONTS_DIR/MesloLGS\ NF\ Bold\ Italic.ttf" 
"https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"


# Refresh font cache

echo "Refreshing font cache..."

fc-cache -f -v


# Display message to restart the terminal

echo "Installation complete. Please restart your terminal to apply changes."
