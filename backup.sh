#!/bin/bash

# chmod +x backup.sh

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 LOG_DIRECTORY BACKUP_DIRECTORY"
    exit 1
fi

LOG_DIRECTORY=$1
BACKUP_DIRECTORY=$2

if [ ! -d "$LOG_DIRECTORY" ]; then
    echo "Error: LOG_DIRECTORY does not exist."
    exit 1
fi

if [ ! -d "$BACKUP_DIRECTORY" ]; then
    mkdir -p "$BACKUP_DIRECTORY"
fi

count=0

for file in "$LOG_DIRECTORY"/*.log.*; do
    if [ -f "$file" ]; then
        cp "$file" "$BACKUP_DIRECTORY"
        count=$((count + 1))
        echo "Copied: $file to $BACKUP_DIRECTORY"
    fi
done

if [ $count -eq 0 ]; then
    echo "No log files found to backup."
else
    echo "$count files backed up to $BACKUP_DIRECTORY."
fi

MAX_BACKUPS=3
BACKUP_COUNT=$(ls -1 "$BACKUP_DIRECTORY" | wc -l)

if [ $BACKUP_COUNT -gt $MAX_BACKUPS ]; then
    echo "Removing oldest backup files..."
    ls -t "$BACKUP_DIRECTORY" | tail -n +$(($MAX_BACKUPS + 1)) | xargs -I {} rm "$BACKUP_DIRECTORY/{}"
    echo "Old backups removed."
fi

echo "Backup complete."
