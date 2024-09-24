#!/bin/bash

# URL of the file to download
FILE_URL="https://raw.githubusercontent.com/scarnecchia/oryx_data/main/totals_by_system.csv"
FILE_NAME="totals_by_system.csv"

# Determine the script's location and set the target directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ "$SCRIPT_DIR" == */RussiaUkraineWarEquipmentLosses/scripts ]]; then
    TARGET_DIR="$SCRIPT_DIR/.."
elif [[ "$SCRIPT_DIR" == */RussiaUkraineWarEquipmentLosses ]]; then
    TARGET_DIR="$SCRIPT_DIR"
else
    echo "Error: This script must be run from either the RussiaUkraineWarEquipmentLosses/ or RussiaUkraineWarEquipmentLosses/scripts/ directory."
    echo "Debug information:"
    echo "Current SCRIPT_DIR: $SCRIPT_DIR"
    echo "Current working directory: $(pwd)"
    echo "Full path to this script: $(readlink -f "$0")"
    exit 1
fi

# Remove the existing file if it exists
if [ -f "$TARGET_DIR/$FILE_NAME" ]; then
    echo "Removing existing $FILE_NAME"
    rm "$TARGET_DIR/$FILE_NAME"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to remove existing $FILE_NAME"
        exit 1
    fi
fi

# Download the file and save it to the target directory
echo "Downloading new $FILE_NAME"
wget -P "$TARGET_DIR" "$FILE_URL"

# Check if the download was successful
if [ $? -eq 0 ]; then
    echo "File downloaded successfully to $TARGET_DIR/$FILE_NAME"
else
    echo "Error: File download failed."
    exit 1
fi
