#!/bin/bash

# Prompt user for SPN names (comma-separated)
read -p "Enter Service Principal Names (comma-separated): " spn_input

# Convert input string into an array
IFS=',' read -r -a spn_names <<< "$spn_input"

# Loop through each SPN and get its object ID
for spn in "${spn_names[@]}"; do
    object_id=$(az ad sp list --display-name "$spn" --query "[].id" -o tsv)
    if [ -n "$object_id" ]; then
        echo "Object ID of $spn: $object_id"
    else
        echo "SPN $spn not found"
    fi
done
