# Run the CSV parser

source("parse_csv.R")

# Ask for the CSV file name
csv_file <- readline(prompt = "Enter the name of the CSV file: ")

# Ask whether the CSV file contains a header
header_input <- readline(prompt = "Does the CSV file contain a header? (TRUE/FALSE): ")

# Ask whether hierarchical JSON should be created
hierarchical <- readline(prompt = "Create hierarchical JSON? (YES/NO): ")

group1 = NULL
group2 = NULL

# If YES, ask for the grouping columns
if (toupper(hierarchical) == "YES") {
  
  # Ask for the first grouping column
  group1 <- readline(prompt = "Group by column: ")
  
  # Ask for an optional second grouping column
  group2 <- readline(prompt = "Second group (leave blank if none): ")
  
  if (group2 == "") {
    group2 <- NULL
  }
}

# Parse the CSV file
result <- parse_csv(csv_file, header_input, group1, group2)

# Print the data frame
print(result$dataframe)

# Save the normal JSON output
writeLines(result$data_JSON, "json_data.json")

# Create and save hierarchical JSON if requested
if (!is.null(group1)) {
  writeLines(result$hierarchical_JSON, "hierarchical_json_data.json")
}

