#!/bin/bash

LOG_FILE=$1

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file does not exist."
    exit 1
fi

echo "Monitoring changes in $LOG_FILE. Press [CTRL+C] to stop."
tail -f "$LOG_FILE"

# bash scripts/support/extract_unique_logs.sh logs/application.log.2024-10-01