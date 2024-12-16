# Load required libraries
library(dplyr)
library(tidymodels)
library(readr)

# Load the model
model_path <- "simple_cricket_model.rds"
model <- readRDS(model_path)

# Load the processed data
data_path <- "processed_cricket_data.csv"
processed_data <- read_csv(data_path)

# Filter for the first 5 overs by Ireland
ireland_data <- processed_data %>%
  filter(team == "Ireland") %>%     
  filter(remaining_overs > 45) |>
  filter(matchid == matchid[1]) # Keep only first 5 Ireland overs for the first game we have in data

# Make predictions
predictions <- ireland_data |> 
  mutate(predicted_runs = predict(model, new_data = ireland_data))

colnames(predictions)[7] = 'runs.predicted'

pred_output <- predictions |> 
  select(team, runs.total, runs.predicted) |> 
  as.data.frame()



# Print the predictions
print(paste0('Predictions for the first 5 overs of Ireland at game 1029001 :'))
print(pred_output, n=30)
