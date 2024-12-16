library(testthat)
library(tidymodels)

# source predict_cricket.R
source('../docker_model/predict_cricket.R')

# Load the model
model_path <- "../docker_model/simple_cricket_model.rds"
model <- readRDS(model_path)

# Load data
data_path <- "../docker_model/processed_cricket_data.csv"
processed_data <- read_csv(data_path)

# Mock data
mock_data <- data.frame(
  matchid = 1:3,
  team = c("Ireland", "Australia", "India"),
  innings = 1,
  remaining_overs = c(45, 40, 35),
  remaining_wickets = c(10, 8, 5),
  runs.total = c(50, 40, 35)
)

# Valid Prediction Test
test_that("Valid predictions are returned", {
  predictions <- make_predictions(model_path, new_data = mock_data, get_valid_teams())
  expect_true(!is.null(predictions))          # Predictions should not be NULL
  expect_equal(nrow(predictions), 3)         # Should return predictions for 3 rows
})

# Invalid Team Test
test_that("Invalid team input is handled gracefully", {
  invalid_data <- mock_data
  invalid_data$team <- "Invalid Team"
  
  expect_error(
    make_predictions(model_path, new_data = invalid_data, get_valid_teams()),
    regexp = "Invalid team\\(s\\) found in input data"  # Match exact error message
  )
})

# Edge Case Test
test_that("Handles edge cases for overs and wickets", {
  edge_case_data <- data.frame(
    matchid = 4,
    team = "Ireland",
    innings = 1,
    remaining_overs = c(50, 0),              # Max and min overs
    remaining_wickets = c(10, 0),            # Max and min wickets
    runs.total = c(0, 0)
  )
  predictions <- make_predictions(model_path, new_data = edge_case_data, get_valid_teams())
  expect_equal(nrow(predictions), 2)        # Should handle both rows
  expect_true(all(predictions$.pred >= 0))  # Predictions should not be negative
})
