library(jsonlite)

# Set working directory
setwd("C:/Users/MartinaImmerkærKrist/OneDrive - Specialisterne/Opgave 1/opgave1")

# Function to parse CSV text to data frame and convert to JSON
parse_csv <- function(csv_text) {
  lines <- strsplit(csv_text, "\n")[[1]]
  
  headers <- strsplit(lines[1], ",")[[1]]
  
  rows <- strsplit(lines[-1], ",")
  
  data <- as.data.frame(do.call(rbind, rows), stringsAsFactors = FALSE)
  colnames(data) <- headers

  data_JSON <- toJSON(x = data, dataframe = 'rows', pretty = TRUE)
  
  list(data = data, data_JSON = data_JSON)
}

# Parse CSV employees text
employees_csv_text <- paste(readLines("employees.ascii.csv"), collapse = "\n")
employees_data <- parse_csv(employees_csv_text)
employees_data_frame <- employees_data$data
employees_JSON <- employees_data$data_JSON

# Parse CSV sogne text
sogne_csv_text <- paste(readLines("sogne.dawa.csv"), collapse = "\n")
sogne_data <- parse_csv(sogne_csv_text)
sogne_data_frame <- sogne_data$data
sogne_JSON <- sogne_data$data_JSON

