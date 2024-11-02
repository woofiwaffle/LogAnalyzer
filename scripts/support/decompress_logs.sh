#!/bin/bash

LOG_DIRECTORY=$1

if [ -z "$LOG_DIRECTORY" ]; then
    echo "Usage: $0 LOG_DIRECTORY"
    exit 1
fi

if [ ! -d "$LOG_DIRECTORY" ]; then
    echo "Error: LOG_DIRECTORY does not exist."
    exit 1
fi

for file in "$LOG_DIRECTORY"/*.gz; do
    if [ -f "$file" ]; then
        gunzip "$file"
        echo "Decompressed: $file"
    fi
done

echo "Log decompression complete."

# bash scripts/support/decompress_logs.sh backup_logs