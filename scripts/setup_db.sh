#!/bin/bash
# AetherVault Database & User Configuration

DB_PATH="$HOME/AetherVault/database/aether.db"
BIN_PATH="$HOME/AetherVault/bin/filebrowser"

echo "Configuring AetherVault Database..."

# 1. Initialize the database
$BIN_PATH config init -d $DB_PATH

# 2. Set Network and Storage rules
$BIN_PATH config set -d $DB_PATH \
  --address 0.0.0.0 \
  --port 8080 \
  --root "$HOME/AetherVault/files" \
  --log "$HOME/AetherVault/aether.log"

# 3. Add the Admin User (Change your password here!)
$BIN_PATH users add admin "${ADMIN_PASSWORD:-admin_default_pass}" -d $DB_PATH --perm.admin

echo "Database initialized. Admin user created."
