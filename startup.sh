#!/bin/bash

# Define variables
REPO_URL="https://github.com/kzinthant-d3v/mydotconfig.git"
CURRENT_USER=$(logname)
CURRENT_HOME=$(eval echo ~${CURRENT_USER})
REPO_DIR="$CURRENT_HOME/mydotconfig"
TARGET_USER="kas"
TARGET_HOME="/home/$TARGET_USER"
TARGET_PASSWORD="kas123"
LOG_FILE="$CURRENT_HOME/startup_log"

# Create or clear the log file
> "$LOG_FILE"

# Function to print status messages
print_status() {
    echo -e "\033[1;32m$1\033[0m" | tee -a "$LOG_FILE"
}

# Clone the repository
print_status "Cloning repository from $REPO_URL..."
if [ ! -d "$REPO_DIR" ]; then
    sudo -u "$CURRENT_USER" git clone "$REPO_URL" "$REPO_DIR" >> "$LOG_FILE" 2>&1
    if [ $? -ne 0 ]; then
        echo "Error: Failed to clone repository." | tee -a "$LOG_FILE"
        exit 1
    fi
else
    echo "Repository already exists at $REPO_DIR. Pulling latest changes..." | tee -a "$LOG_FILE"
    cd "$REPO_DIR" || exit
    sudo -u "$CURRENT_USER" git pull >> "$LOG_FILE" 2>&1
    if [ $? -ne 0 ]; then
        echo "Error: Failed to pull latest changes." | tee -a "$LOG_FILE"
        exit 1
    fi
fi

cd "$REPO_DIR" || exit

# List of scripts to execute in order
SCRIPTS=(
    "z.sh"
    "t.sh"
    "apps.sh"
    "neovim.sh"
    "p10k.sh"
    "lg.sh"
    "go.sh"
)

# Execute each script in order as the current user
for script in "${SCRIPTS[@]}"; do
    print_status "Running $script as $CURRENT_USER..."
    if [ -f "$script" ]; then
        sudo -u "$CURRENT_USER" bash -c "cd $REPO_DIR && chmod +x $script && ./$script" >> "$LOG_FILE" 2>&1
        if [ $? -ne 0 ]; then
            echo "Error: $script failed." | tee -a "$LOG_FILE"
            exit 1
        fi
    else
        echo "Error: $script not found." | tee -a "$LOG_FILE"
        exit 1
    fi
done

# Copy configuration files to the current user's home directory
CONFIG_FILES=(
    ".config"
    ".tmux.conf"
)

for config_file in "${CONFIG_FILES[@]}"; do
    if [ -e "$REPO_DIR/$config_file" ]; then
        print_status "Copying $config_file to $CURRENT_HOME..."
        sudo cp -r "$REPO_DIR/$config_file" "$CURRENT_HOME/" >> "$LOG_FILE" 2>&1
        sudo chown -R "$CURRENT_USER:$CURRENT_USER" "$CURRENT_HOME/$config_file" >> "$LOG_FILE" 2>&1
        if [ $? -ne 0 ]; then
            echo "Error: Failed to copy $config_file." | tee -a "$LOG_FILE"
            exit 1
        fi
    else
        echo "Warning: $config_file not found." | tee -a "$LOG_FILE"
    fi
done

# Create the user 'kas' with sudo privileges
print_status "Creating user $TARGET_USER with sudo privileges..."
sudo useradd -m -s /bin/bash "$TARGET_USER" >> "$LOG_FILE" 2>&1
echo "$TARGET_USER:$TARGET_PASSWORD" | sudo chpasswd >> "$LOG_FILE" 2>&1
sudo usermod -aG sudo "$TARGET_USER" >> "$LOG_FILE" 2>&1

# Copy all files from the current user's home to kas's home
print_status "Copying files from $CURRENT_HOME to $TARGET_HOME..."
sudo rsync -a --chown="$TARGET_USER:$TARGET_USER" "$CURRENT_HOME/" "$TARGET_HOME/" >> "$LOG_FILE" 2>&1

print_status "Setup complete."
