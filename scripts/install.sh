#!/bin/bash
# AetherVault Installation Script

echo "Starting AetherVault Environment Setup..."

# 1. Get the directory where THIS script is located
# This makes the project work regardless of the folder name
PROJECT_ROOT=$(cd "$(dirname "$0")/.." && pwd)

echo "Installing to: $PROJECT_ROOT"

# 2. Create Directory Structure relative to the project root
mkdir -p "$PROJECT_ROOT/files"
mkdir -p "$PROJECT_ROOT/database"
mkdir -p "$PROJECT_ROOT/bin"

# 3. Download FileBrowser Binary
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

# 4. Move binary to the project's bin folder
# We use sudo because the curl script puts it in /usr/local/bin by default
sudo mv /usr/local/bin/filebrowser "$PROJECT_ROOT/bin/"

echo "Directories created and binary installed in $PROJECT_ROOT/bin/"
