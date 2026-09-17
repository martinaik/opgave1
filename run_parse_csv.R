source("parse_csv.R")

csv_file <- readline(prompt = "Enter the name of the CSV file: ")

result <- parse_csv(csv_file)

print(result$data)
cat(result$data_JSON)