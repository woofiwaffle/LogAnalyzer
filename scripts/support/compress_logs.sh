#!/bin/bash

LOG_DIRECTORY=$1

if [ ! -d "$LOG_DIRECTORY" ]; then
    echo "Error: LOG_DIRECTORY does not exist."
    exit 1
fi

for file in "$LOG_DIRECTORY"/*.log.*; do
    if [ -f "$file" ]; then
        gzip "$file"
        echo "Compressed: $file"
    fi
done

echo "Log compression complete."

# bash scripts/support/compress_logs.sh backup_logs