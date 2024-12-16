library(testthat)
library(dplyr)
library(tidymodels)

# source predict_cricket.R
source('../data_modelling.R')

# Mock data
mock_data <- data.frame(
  remaining_overs = c(45, 40, 35, 30, 25),
  remaining_wickets = c(10, 9, 8, 7, 6),
  runs.total = c(50, 45, 40, 35, 30)
)

mock_output_path <- "./mock_model.rds"

# Test: Prepare Data
test_that("prepare_data splits data correctly", {
  data_splits <- prepare_data(data_path = "./data/processed_cricket_data.csv", split_ratio = 0.8)
  expect_true("train_data" %in% names(data_splits))
  expect_true("test_data" %in% names(data_splits))
  expect_gt(nrow(data_splits$train_data), 0)  # Training data should not be empty
  expect_gt(nrow(data_splits$test_data), 0)   # Testing data should not be empty
})

# Test: Train Model
test_that("train_model trains a workflow", {
  data_splits <- prepare_data(data_path = "data/processed_cricket_data.csv")
  train_data <- data_splits$train_data
  model <- train_model(train_data)
  
  expect_s3_class(model, "workflow")
})

# Test: Evaluate Model
test_that("evaluate_model returns metrics", {
  data_splits <- prepare_data(data_path = "data/processed_cricket_data.csv")
  train_data <- data_splits$train_data
  test_data <- data_splits$test_data
  model <- train_model(train_data)
  metrics <- evaluate_model(model, test_data)
  
  expect_true("metric" %in% colnames(metrics))
  expect_true("estimate" %in% colnames(metrics))
})

# Test: Save Model
test_that("save_model saves the model to disk", {
  data_splits <- prepare_data(data_path = "data/processed_cricket_data.csv")
  train_data <- data_splits$train_data
  model <- train_model(train_data)
  
  save_model(model, mock_output_path)
  expect_true(file.exists(mock_output_path))
  unlink(mock_output_path)  # Cleanup
})
