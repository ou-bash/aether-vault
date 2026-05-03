#!/bin/bash
BACKUP_DIR=~/AetherVault_Backups
mkdir -p $BACKUP_DIR

# Timestamp for the filename
TIMESTAMP=$(date +"%Y-%m-%d_%H%M%S")

# Backup the DB and the Files folder
tar -czf "$BACKUP_DIR/aether_backup_$TIMESTAMP.tar.gz" -C ~/project/project-ssh-cloud/aether-vault database files

# Keep only the last 7 days of backups (Clean up old ones)
find $BACKUP_DIR -type f -mtime +7 -name "*.tar.gz" -delete

echo "Backup completed: $BACKUP_DIR/aether_backup_$TIMESTAMP.tar.gz"
