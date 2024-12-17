#!/bin/bash

# Ensure the script stops on errors
set -e

# Set the path to your R script
R_SCRIPT="run_model.R"

# Prompt the user for input
echo "Please select an option:"
echo "1: Run a demo with the first 5 Ireland overs"
echo "2: Provide your own dataset"

# Read the user's input
read -p "Enter your choice (1 or 2): " user_choice

# Based on the input, run the R script with the appropriate argument
if [ "$user_choice" == "1" ]; then
  Rscript $R_SCRIPT 1
elif [ "$user_choice" == "2" ]; then
 echo "Paste your data (separate by comma) directly (Ctrl+D to finish):"

  cat > /tmp/user_data.csv
  
  # Run the R script with the uploaded dataset
  Rscript $R_SCRIPT 2 /tmp/user_data.csv
else
  echo "Invalid option. Please enter 1 or 2."
fi
