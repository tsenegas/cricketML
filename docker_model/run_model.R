#!/usr/bin/env Rscript

# Load required libraries
library(dplyr)
library(tidymodels)
library(readr)

# Load the model
model_path <- "simple_cricket_model.rds"

# Load the processed data
data_path <- "processed_cricket_data.csv"
processed_data <- read_csv(data_path)


# Define valid teams (to avoid dependency on processed data directly)
get_valid_teams <- function(processed_data_path) {
  processed_data <- read_csv(data_path)
  return(unique(processed_data$team))
}

# Function to make predictions
make_predictions <- function(new_data, model_path, valid_teams = get_valid_teams()) {
  # Load the model
  model <- readRDS(model_path)
  
  # Validate input data
  if (!all(new_data$team %in% valid_teams)) {
    stop("Invalid team(s) found in input data")
  }
  
  # Make predictions
  predictions <- new_data |> 
    mutate(predicted_runs = predict(model, new_data = new_data))
  
  return(predictions)
}

# Parse command-line arguments
args <- commandArgs(trailingOnly = TRUE)

# Validate arguments
if (length(args) < 1) {
  cat("Error: Missing arguments.\n")
  cat("Usage:\n")
  cat("   Rscript run_model.R 1\n")
  cat("   Rscript run_model.R 2 /path/to/your_dataset.csv\n")
  stop("Execution halted.")
}

option <- args[1]

# Option 1: Run the demo
if (option == "1") {
  cat("\nRunning demo with the first 5 Ireland overs...\n")
  
  # Load the processed data
  processed_data <- read_csv(data_path, show_col_types = FALSE)
  
# Filter for the first 5 overs by Ireland
ireland_data <- processed_data |> 
  filter(team == "Ireland") |>    
  filter(remaining_overs > 45) |>
  filter(matchid == matchid[1]) # Keep only first 5 Ireland overs for the first game we have in data

predictions <- make_predictions(new_data = ireland_data, model_path, get_valid_teams())

colnames(predictions)[7] = 'runs.predicted'

pred_output <- predictions |> 
  select(team, runs.total, runs.predicted)

  cat("\nPredictions for the first 5 overs of Ireland at game 1029001:\n")
  print(pred_output, n = 30)

# Option 2: User-provided dataset
} else if (option == "2") {
  # Check if dataset path is provided
  if (length(args) < 2) {
    stop("Error: Please provide the path to your dataset.\nUsage: Rscript run_model.R 2 /path/to/your_dataset.csv")
  }
  
  input_path <- args[2]
  
  # Validate file existence
  if (!file.exists(input_path)) {
    stop("Error: File not found. Please provide a valid file path.")
  }
  
  cat("\nLoading user-provided dataset...\n")
  
  # Load the user-provided dataset
  user_data <- read_csv(input_path, show_col_types = FALSE)

  # Required columns
  required_columns <- c("remaining_overs", "remaining_wickets", "team")
  
  # Check for missing columns
  missing_columns <- setdiff(required_columns, colnames(user_data))
  if (length(missing_columns) > 0) {
    cat("Error: The following required columns are missing from your dataset:\n")
    cat(paste(missing_columns, collapse = ", "), "\n")
    cat("Please ensure that your dataset includes at least the following columns:\n")
    cat(paste(required_columns, collapse = ", "), "\n")
    stop("Execution halted.")
  }
  
  
  # Make predictions
  predictions <- make_predictions(new_data = user_data, model_path, get_valid_teams())
  
  # Format and display predictions
  pred_output <- predictions |> 
    select(team, predicted_runs)

  cat("\nModel Predictions:\n")
  print(pred_output, n = 30)

# Invalid Option
} else {
  stop("Invalid option. Please use 1 for demo or 2 to provide a dataset.")
}
