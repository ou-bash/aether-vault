#!/bin/bash
# AetherVault Database & User Configuration

PROJECT_ROOT=$(cd "$(dirname "$0")/.." && pwd)

# 1. Load variables from .env file
if [ -f "$PROJECT_ROOT/.env" ]; then
    set -a
    # shellcheck source=/dev/null
    [ -f "$PROJECT_ROOT/.env" ] && . "$PROJECT_ROOT/.env"
    set +a

else
    echo "Error: .env file not found!"
    echo "Please copy .env.example to .env and fill in your credentials."
    exit 1
fi

DB_PATH="$PROJECT_ROOT/database/aether.db"
BIN_PATH="$PROJECT_ROOT/bin/filebrowser"

echo "Configuring AetherVault for user: $VAULT_ADMIN_USER"

# 2. Initialize the database
$BIN_PATH config init -d "$DB_PATH"

# 3. Set Network and Storage rules
$BIN_PATH config set -d "$DB_PATH" \
  --address 0.0.0.0 \
  --port "$VAULT_PORT" \
  --root "$PROJECT_ROOT/files" \
  --log "$PROJECT_ROOT/aether.log"

# 4. Add the User from the .env variables
$BIN_PATH users add "$VAULT_ADMIN_USER" "$VAULT_ADMIN_PASSWORD" -d "$DB_PATH" --perm.admin

echo "Configuration complete. Access your vault on port $VAULT_PORT"

# 5. Generate the real service file from the template
echo "Generating customized systemd service file..."

# This 'sed' command swaps the placeholders for real paths
sed -e "s|{{PROJECT_ROOT}}|$PROJECT_ROOT|g" \
    -e "s|{{USER}}|$USER|g" \
    "$PROJECT_ROOT/systemd/aether.service.template" > "$PROJECT_ROOT/systemd/aether.service"

echo "Service file generated at $PROJECT_ROOT/systemd/aether.service"
