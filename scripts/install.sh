#!/bin/bash
# AetherVault Installation Script

echo "Starting AetherVault Environment Setup..."

# 1. Create Directory Structure
mkdir -p ~/AetherVault/files
mkdir -p ~/AetherVault/database
mkdir -p ~/AetherVault/bin

# 2. Download FileBrowser Binary
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

# 3. Move binary to project folder for portability
sudo mv /usr/local/bin/filebrowser ~/AetherVault/bin/

echo " Directories created and binary installed in ~/AetherVault/bin/"
