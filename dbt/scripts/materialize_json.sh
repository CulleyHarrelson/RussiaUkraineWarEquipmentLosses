#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Database name
DB_NAME="dbt_equipment_losses"

# Array of models to convert
MODELS=(
    "system_category"
    "cumulative_losses"
    "unknown_equipment"
    "equipment_analysis"
)

# Create data directory if it doesn't exist
mkdir -p data

# Check if jq is installed
if ! command -v jq &>/dev/null; then
    echo "Error: jq is not installed. Please install jq to format JSON."
    exit 1
fi

# Loop through each model and convert to JSON
for MODEL in "${MODELS[@]}"; do
    echo "Converting $MODEL to JSON..."

    # Use psql to query the table/view and output as JSON
    if ! psql -d "$DB_NAME" -t -A -c "SELECT json_agg(t) FROM $MODEL t;" >"data/${MODEL}_temp.json"; then
        echo "Error: Failed to query $MODEL from the database."
        continue
    fi

    # Check if the file is empty
    if [ ! -s "data/${MODEL}_temp.json" ]; then
        echo "Error: No data retrieved for $MODEL."
        rm "data/${MODEL}_temp.json"
        continue
    fi

    # Format the JSON using jq and save to final file
    if ! jq '.' "data/${MODEL}_temp.json" >"data/$MODEL.json"; then
        echo "Error: Failed to format JSON for $MODEL."
        rm "data/${MODEL}_temp.json"
        continue
    fi

    # Remove the temporary file
    rm "data/${MODEL}_temp.json"

    echo "Completed $MODEL. Formatted JSON file saved as data/$MODEL.json"
done

echo "All conversions complete."
