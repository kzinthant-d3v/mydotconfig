#!/bin/bash

# Script to create a user, set password, grant sudo access, enable SSH, and switch to the new user

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
	  echo "This script must be run as root."
	    exit 1
fi

# Variables
USERNAME="kaskar"
PASSWORD="kaskar123!"

# Create the user with a default home directory
useradd -m -s /bin/bash "$USERNAME"

# Set the user's password
echo "$USERNAME:$PASSWORD" | chpasswd

# Add the user to the sudo group
usermod -aG sudo "$USERNAME"

# Check if the user was successfully added to the sudo group
if id -nG "$USERNAME" | grep -qw "sudo"; then
	  echo "User $USERNAME created and added to the sudo group successfully."
  else
	    echo "Failed to add $USERNAME to the sudo group."
	      exit 1
fi

# Enable SSH service
if systemctl is-active --quiet ssh; then
	  echo "SSH is already enabled."
  else
	    echo "Enabling SSH service..."
	      systemctl enable ssh
	        systemctl start ssh
		  echo "SSH service enabled."
fi

# Switch to the new user
echo "Switching to the new user: $USERNAME"
su - "$USERNAME"


