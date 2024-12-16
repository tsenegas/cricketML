#!/bin/bash

# Ensure the script stops on errors
set -e

# Path to R script
R_SCRIPT="predict_cricket.R"

# Run the R script and display the output
Rscript $R_SCRIPT