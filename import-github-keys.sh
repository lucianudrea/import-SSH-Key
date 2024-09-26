#!/bin/bash

# Check if two parameters were provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <github_user> <local_user>"
    exit 1
fi

# Input parameters
USER_GITHUB=$1  # GitHub username (first parameter)
USER_LOCAL=$2   # Local username on the server (second parameter)

# Set the correct path for the .ssh directory based on the local user
if [ "$USER_LOCAL" == "root" ]; then
    SSH_DIR="/root/.ssh"
else
    SSH_DIR="/home/$USER_LOCAL/.ssh"
fi

# Create the .ssh directory if it doesn't already exist
mkdir -p $SSH_DIR

# Fetch and append the GitHub user's SSH keys to authorized_keys
curl https://github.com/$USER_GITHUB.keys >> $SSH_DIR/authorized_keys

# Set the correct ownership and permissions for the files
if [ "$USER_LOCAL" == "root" ]; then
    chown root:root $SSH_DIR/authorized_keys
else
    chown $USER_LOCAL:$USER_LOCAL $SSH_DIR/authorized_keys
fi

chmod 600 $SSH_DIR/authorized_keys
chmod 700 $SSH_DIR

echo "SSH keys from GitHub user $USER_GITHUB have been imported for local user $USER_LOCAL."
