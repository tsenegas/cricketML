# Load required libraries
library(tidymodels)
library(dplyr)
library(readr)


# Function: Prepare data for modeling
prepare_data <- function(data_path, split_ratio = 0.8) {
  # Load processed data
  processed_data <- read_csv(data_path)
  
  # Select relevant columns
  model_data <- processed_data |> 
    select(remaining_overs, remaining_wickets, runs.total)
  
  # Split the data into training and testing sets
  set.seed(123)  # For reproducibility
  data_split <- initial_split(model_data, prop = split_ratio)
  
  list(train_data = training(data_split), test_data = testing(data_split))
}

# Function: Train the model
train_model <- function(train_data) {
  # Define a linear regression model specification
  lm_spec <- linear_reg() %>%
    set_engine("lm") %>%
    set_mode("regression")
  
  # Create a recipe for preprocessing
  lm_recipe <- recipe(runs.total ~ remaining_overs + remaining_wickets, data = train_data)
  
  # Create a workflow combining the recipe and model
  lm_workflow <- workflow() %>%
    add_recipe(lm_recipe) %>%
    add_model(lm_spec)
  
  # Fit the model on the training data
  lm_fit <- lm_workflow %>%
    fit(data = train_data)
  
  return(lm_fit)
}

# Function: Evaluate the model
evaluate_model <- function(model, test_data) {
  test_results <- model %>%
    predict(test_data) %>%
    bind_cols(test_data) %>%
    metrics(truth = runs.total, estimate = .pred)
  
  return(test_results)
}

# Function: Save the model to disk
save_model <- function(model, output_path) {
  saveRDS(model, file = output_path)
}

# Main script logic
data_path <- "data/processed_cricket_data.csv"  # Path to processed data
model_output_path <- "./model/simple_cricket_model.rds"  # Model save path

# Step 1: Prepare data
data_splits <- prepare_data(data_path)
train_data <- data_splits$train_data
test_data <- data_splits$test_data

# Step 2: Train the model
lm_fit <- train_model(train_data)

# Step 3: Evaluate the model
test_results <- evaluate_model(lm_fit, test_data)
print(test_results)

# Step 4: Save the model
save_model(lm_fit, model_output_path)
