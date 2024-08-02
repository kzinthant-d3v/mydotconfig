#!/bin/bash

# Define variables
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
P10K_CONFIG_URL="https://raw.githubusercontent.com/romkatv/dotfiles-public/master/.p10k.zsh"
FONTS_DIR="$HOME/.local/share/fonts"
FONT_URL_PREFIX="https://github.com/romkatv/powerlevel10k-media/raw/master"
FONT_FILES=("MesloLGS NF Regular.ttf" "MesloLGS NF Bold.ttf" "MesloLGS NF Italic.ttf" "MesloLGS NF Bold Italic.ttf")

# Function to print status messages
print_status() {
    echo -e "\033[1;32m$1\033[0m"
}

# Function to install packages
install_packages() {
    local packages=("$@")
    sudo apt-get update -y
    sudo apt-get install -y "${packages[@]}"
}

# Install necessary packages
print_status "Installing Zsh and other necessary packages..."
install_packages zsh curl git fonts-powerline

# Install Oh My Zsh
print_status "Installing Oh My Zsh..."
sudo su -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended' $SUDO_USER

# Install Powerlevel10k theme
print_status "Installing Powerlevel10k..."
sudo su -c "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k" $SUDO_USER

# Set Zsh as the default shell
print_status "Setting Zsh as the default shell..."
sudo chsh -s "$(which zsh)" $SUDO_USER

# Update .zshrc to use Powerlevel10k
print_status "Configuring .zshrc to use Powerlevel10k..."
sudo su -c "sed -i 's/ZSH_THEME=\".*\"/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/' ~/.zshrc" $SUDO_USER

# Install recommended Nerd Fonts
print_status "Installing recommended Nerd Fonts..."
sudo su -c "mkdir -p $FONTS_DIR && cd $FONTS_DIR" $SUDO_USER

for font_file in "${FONT_FILES[@]}"; do
    su -c "curl -fLo '$FONTS_DIR/$font_file' '$FONT_URL_PREFIX/$font_file'" $SUDO_USER
done

# Refresh the font cache
print_status "Refreshing font cache..."
sudo su -c "fc-cache -f -v" $SUDO_USER

# Download Powerlevel10k configuration
print_status "Downloading Powerlevel10k configuration..."
sudo su -c "curl -fsSL '$P10K_CONFIG_URL' -o ~/.p10k.zsh" $SUDO_USER

# Ensure Git info is shown in the prompt
# Modify .p10k.zsh to ensure Git branch information is visible
print_status "Ensuring Git branch information is visible in the prompt..."
sudo su -c "sed -i '/POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=/c\\POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)' ~/.p10k.zsh" $SUDO_USER
sudo su -c "sed -i '/POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=/c\\POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)' ~/.p10k.zsh" $SUDO_USER

# Update .zshrc to source the Powerlevel10k configuration
sudo su -c "echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc" $SUDO_USER

print_status "Powerlevel10k installation and configuration complete."
print_status "Please set your terminal font to 'MesloLGS NF'."
print_status "Open a new terminal window or restart your terminal session."
