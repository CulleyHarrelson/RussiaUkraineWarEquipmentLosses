#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Database name
DB_NAME="dbt_equipment_losses"

# Array of models to convert
MODELS=(
    "system_category"
)

# Create json directory if it doesn't exist
mkdir -p json

# Check if jq is installed
if ! command -v jq &>/dev/null; then
    echo "Error: jq is not installed. Please install jq to format JSON."
    exit 1
fi

# Loop through each model and convert to JSON
for MODEL in "${MODELS[@]}"; do
    echo "Converting $MODEL to JSON..."

    # Use psql to query the table/view and output as JSON
    if ! psql -d "$DB_NAME" -t -A -c "SELECT json_agg(t) FROM $MODEL t;" >"json/${MODEL}_temp.json"; then
        echo "Error: Failed to query $MODEL from the database."
        continue
    fi

    # Check if the file is empty
    if [ ! -s "json/${MODEL}_temp.json" ]; then
        echo "Error: No data retrieved for $MODEL."
        rm "json/${MODEL}_temp.json"
        continue
    fi

    # Format the JSON using jq and save to final file
    if ! jq '.' "json/${MODEL}_temp.json" >"json/$MODEL.json"; then
        echo "Error: Failed to format JSON for $MODEL."
        rm "json/${MODEL}_temp.json"
        continue
    fi

    # Remove the temporary file
    rm "json/${MODEL}_temp.json"

    echo "Completed $MODEL. Formatted JSON file saved as json/$MODEL.json"
done

echo "All conversions complete."
