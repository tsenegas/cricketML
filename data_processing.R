
#test = jsonlite::fromJSON('./data/match_results.json')
#test2 =jsonlite::fromJSON('../../cricketML_data/innings_results.json')


#sample_innings_results = head(test2, 2000)
#sample_match_results = head(test,2000)

#write.csv(sample_match_results, '../../cricketML_data/sample_match_results.csv', row.names = F)
#write.csv(sample_innings_results, '../../cricketML_data/sample_innings_results.csv', row.names = F)

#testouille = read.csv('../../cricketML_data/sample_innings_results.csv')


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


#processed_data <- merged_data |> 
#  group_by(matchid, innings) |> 
#  mutate(
#    remaining_overs = 50 - floor(as.numeric(over)),
#    cumulative_wickets = cumsum(ifelse(runs.total == 0 & !is.na(over), 1, 0)), # Simplified wicket calculation
#    remaining_wickets = 10 - cumulative_wickets
#  ) |> 
#  ungroup() |> 
#  select(matchid, team, innings, remaining_overs, remaining_wickets, runs.total)


write.csv(processed_innings, "data/processed_innings.csv", row.names = FALSE)


