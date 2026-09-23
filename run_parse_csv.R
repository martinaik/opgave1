# Run the CSV parser

source("parse_csv.R")

csv_file <- readline(prompt = "Enter the name of the CSV file: ")
header_input <- readline(prompt = "Does the CSV file contain a header? (TRUE/FALSE): ")

result <- parse_csv(csv_file, header_input)

print(result$dataframe)
cat(result$data_JSON)
