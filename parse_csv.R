library(jsonlite)

setwd("C:/Users/MartinaImmerkærKrist/OneDrive - Specialisterne/Opgave 1/opgave1")

# Parse CSV file into data frame and JSON
parse_csv <- function(csv_file) {
  
  csv_text <- paste(readLines(csv_file), collapse = "\n")
  
  lines <- strsplit(csv_text, "\n")[[1]]
  
  headers <- parse_row(lines[1])
  
  rows <- lapply(lines[-1], parse_row)
  
  # Check that every row has the same number of fields as the header
  expected_fields <- length(headers)
  
  for (i in seq_along(rows)) {
    if (length(rows[[i]]) != expected_fields) {
      stop(paste(
        "Invalid CSV format: row", i + 1,
        "contains", length(rows[[i]]),
        "fields, expected", expected_fields
      ))
    }
  }
  
  # Handle file containing only a header
  if (length(rows) == 0) {
    data <- as.data.frame(matrix(nrow = 0, ncol = length(headers)))
    colnames(data) <- headers
  } else {
    data <- as.data.frame(do.call(rbind, rows), stringsAsFactors = FALSE)
    colnames(data) <- headers
  }
  
  # Convert to JSON format
  data_JSON <- toJSON(data, dataframe = "rows", pretty = TRUE)
  
  # Return results
  list(data = data, data_JSON = data_JSON)
}

# Function to parse one row
parse_row <- function(line) {
  
  fields <- c()
  field <- ""
  inside_quotes <- FALSE
  
  chars <- strsplit(line, "")[[1]]
  
  i <- 1
  while (i <= length(chars)) {
    
    char <- chars[i]
    
    if (char == '"') {
      
      # Handle escaped quotation marks ("")
      if (inside_quotes &&
          i < length(chars) &&
          chars[i + 1] == '"') {
        
        field <- paste0(field, '"')
        i <- i + 1
        
      } else {
        # Enter or leave quoted field
        inside_quotes <- !inside_quotes
      }
      
    } else if (char == "," && !inside_quotes) {
      
      # Comma outside quotes ends a field
      fields <- c(fields, field)
      field <- ""
      
    } else {
      
      # Add character to current field
      field <- paste0(field, char)
    }
    
    i <- i + 1
  }
  
  # Add the last field
  fields <- c(fields, field)
  
  fields
}
