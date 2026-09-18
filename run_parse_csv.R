# Run the CSV parser

source("parse_csv.R")

csv_file <- readline(prompt = "Enter the name of the CSV file: ")

result <- parse_csv(csv_file)

print(result$dataframe)
cat(result$data_JSON)
