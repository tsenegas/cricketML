# Load required libraries
library(dplyr)
library(jsonlite)

# Read raw Json files
match_data = jsonlite::fromJSON('./data/match_results.json')
innings_data = jsonlite::fromJSON('../../cricketML_data/innings_results.json')

# Process the data for Q3a
# Step 1: Filter out no-result matches
valid_match_ids <- match_data |> 
  dplyr::filter(is.na(result) | result == 'tie') |> 
  dplyr::pull(matchid) |> 
  unique()

# Step 2: Filter innings data to include only valid matches
filtered_innings <- innings_data |> 
  dplyr::filter(matchid %in% valid_match_ids)

# Step 3: Add remaining overs and remaining wickets
processed_innings <- filtered_innings |> 
  group_by(matchid, team) |> 
  mutate(
    over_number = floor(as.numeric(over)), # Extract the integer part of over (e.g., 0.1 becomes 0)
    remaining_overs = 50 - over_number, # Calculate remaining overs (assuming 50 overs max)
    remaining_wickets = 10 - cumsum(!is.na(wicket.player_out)), # Count dismissals cumulatively
    inning_order = innings # Keep innings column for clarity
  ) |> 
  select(team, inning_order, remaining_overs, remaining_wickets, matchid)

write.csv(processed_innings, "data/processed_innings.csv", row.names = FALSE)


