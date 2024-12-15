# Load required libraries
library(tidyverse)

# Load the model
model_path <- "./model/simple_cricket_model.rds"
model <- readRDS(model_path)

# Load the processed data
data_path <- "./data/processed_cricket_data.csv"
processed_data <- read_csv(data_path)

# Filter for the first 5 overs by Ireland
ireland_data <- processed_data %>%
  filter(team == "Ireland", remaining_overs <= 45) %>%
  slice_head(n = 5)

# Make predictions
predictions <- ireland_data %>%
  mutate(predicted_runs = predict(model, new_data = ireland_data))

# Print the predictions
print(predictions)
