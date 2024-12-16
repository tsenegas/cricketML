library(testthat)

# Load the model
model_path <- "./docker_model/simple_cricket_model.rds"
model <- readRDS(model_path)

# Mock Data
mock_data <- data.frame(
  matchid = 1,
  team = c("Ireland", "Australia", "India"),
  innings = 1,
  remaining_overs = c(45, 40, 35),
  remaining_wickets = c(10, 8, 5),
  runs.total = c(50, 40, 35)
)

test_that("Predictions work for valid inputs", {
  predictions <- predict(model, new_data = mock_data)
  expect_true(!is.null(predictions))          # Predictions should not be null
  expect_equal(nrow(predictions), 3)         # Predictions for 3 rows
})

test_that("Handles invalid teams gracefully", {
  invalid_data <- mock_data
  invalid_data$team <- "Invalid Team"
  
  expect_error(
    predict(model, new_data = invalid_data),
    regexp = "team not found"                 # Replace with actual error message
  )
})

test_that("Handles edge cases for overs and wickets", {
  edge_case_data <- data.frame(
    matchid = 1,
    team = "Ireland",
    innings = 1,
    remaining_overs = c(50, 0),              # Max and min overs
    remaining_wickets = c(10, 0),            # Max and min wickets
    runs.total = c(0, 0)
  )
  
  predictions <- predict(model, new_data = edge_case_data)
  expect_equal(nrow(predictions), 2)        # Should handle both rows
  expect_true(all(predictions$.pred >= 0))  # Predictions should not be negative
})
