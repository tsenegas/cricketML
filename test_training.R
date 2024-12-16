library(testthat)

# Path to mock training data
training_data_path <- "mock_training_data.csv"

# Mock training data
mock_training_data <- data.frame(
  matchid = rep(1:3, each = 10),
  team = rep(c("Ireland", "Australia", "India"), each = 10),
  innings = 1,
  remaining_overs = rep(50:41, times = 3),
  remaining_wickets = rep(10:1, times = 3),
  runs.total = sample(30:100, 30, replace = TRUE)
)

# Save mock data for testing
write.csv(mock_training_data, training_data_path, row.names = FALSE)

test_that("Training script saves model artifacts", {
  source("training_script.R")  # Replace with the actual training script file
  trained_model <- train_model(training_data_path)  # Replace with actual function
  
  # Check if model file is saved
  expect_true(file.exists("simple_cricket_model.rds"))
  
  # Check the model object
  expect_s3_class(trained_model, "workflow")
})

test_that("Training script handles missing data gracefully", {
  incomplete_data <- mock_training_data[-1, ]  # Remove one row
  
  expect_error(
    train_model(incomplete_data),             # Replace with actual function
    regexp = "missing data"                   # Replace with actual error message
  )
})
