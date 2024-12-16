# Load required libraries
library(dplyr)
library(tidymodels)
library(readr)

# Load the model
model_path <- "simple_cricket_model.rds"
#model <- readRDS(model_path)

# Load the processed data
data_path <- "processed_cricket_data.csv"
processed_data <- read_csv(data_path)

# Define valid teams (to avoid dependency on processed data directly)
get_valid_teams <- function(processed_data_path) {
  processed_data <- read_csv(data_path)
  return(unique(processed_data$team))
}


# Define valid teams
#valid_teams <- unique(processed_data$team)  # Add all valid teams here

# Define a prediction function
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

# Filter for the first 5 overs by Ireland
ireland_data <- processed_data |> 
  filter(team == "Ireland") |>    
  filter(remaining_overs > 45) |>
  filter(matchid == matchid[1]) # Keep only first 5 Ireland overs for the first game we have in data


predictions <- make_predictions(new_data = ireland_data, model_path, get_valid_teams())

colnames(predictions)[7] = 'runs.predicted'

pred_output <- predictions |> 
  select(team, runs.total, runs.predicted)

# Print the predictions
print(paste0('Predictions for the first 5 overs of Ireland at game 1029001 :'))
print(pred_output, n=30)