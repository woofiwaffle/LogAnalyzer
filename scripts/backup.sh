#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 LOG_DIRECTORY BACKUP_DIRECTORY"
    exit 1
fi

LOG_DIRECTORY=$1
BACKUP_DIRECTORY=$2

if [ ! -d "$LOG_DIRECTORY" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') Error: LOG_DIRECTORY does not exist."
    exit 1
fi

if [ ! -d "$BACKUP_DIRECTORY" ]; then
    mkdir -p "$BACKUP_DIRECTORY"
    echo "$(date '+%Y-%m-%d %H:%M:%S') Created backup directory: $BACKUP_DIRECTORY"
fi

count=0

for file in $(find "$LOG_DIRECTORY" -type f -name "*.log.*"); do
    if cp "$file" "$BACKUP_DIRECTORY"; then
        count=$((count + 1))
        echo "$(date '+%Y-%m-%d %H:%M:%S') Copied: $file to $BACKUP_DIRECTORY"
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') Warning: Failed to copy $file"
    fi
done

if [ $count -eq 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') No log files found to backup."
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') $count files backed up to $BACKUP_DIRECTORY."
fi

MAX_BACKUPS=7
BACKUP_COUNT=$(ls -1 "$BACKUP_DIRECTORY" | wc -l)

if [ $BACKUP_COUNT -gt $MAX_BACKUPS ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') Removing oldest backup files..."
    ls -t "$BACKUP_DIRECTORY" | tail -n +$(($MAX_BACKUPS + 1)) | while read -r file; do
        rm "$BACKUP_DIRECTORY/$file"
        echo "$(date '+%Y-%m-%d %H:%M:%S') Removed: $file"
    done
    echo "$(date '+%Y-%m-%d %H:%M:%S') Old backups removed."
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') Backup complete."