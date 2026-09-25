# Opgave 1 - Parser opgave

# Function to parse CSV file into data frame and JSON format
parse_csv <- function(csv_file, has_header = TRUE, group1 = NULL, group2 = NULL){
  
  # Read the file as one text string
  csv_text <- paste(readLines(csv_file), collapse = "\n") 
  
  # Split the text into lines
  lines <- strsplit(csv_text, "\n")[[1]] 
  
  # Check whether the CSV file contains a header row
  if (has_header) {
    headers <- parse_row(lines[1]) # Extract the header row as column names
    rows <- lapply(lines[-1], parse_row) # Split each line into rows
  } else {
    first_row <- parse_row(lines[1]) # Parse the first row to determine the number of columns
    headers <- paste0("V", seq_along(first_row)) # Create default column names
    rows <- lapply(lines, parse_row) # Split each line into rows
  }

  # Check that every row has the same number of fields as the header
  expected_fields <- length(headers)
  for (i in seq_along(rows)) {
    if (length(rows[[i]]) != expected_fields) {
      stop(paste("Row", i + 1, "has the wrong number of fields."))
    }
  }
  
  # Handle file containing only a header
  if (length(rows) == 0){
    dataframe <- as.data.frame(matrix(nrow = 0, ncol = length(headers))) # Create data frame with zero rows
    colnames(dataframe) <- headers
  } else{
    dataframe <- as.data.frame(do.call(rbind, rows), stringsAsFactors = FALSE) # Combine the rows into a data frame
    colnames(dataframe) <- headers
  }
  
  # Convert to JSON format
  data_JSON <- data_to_json(dataframe)
  
  # Convert to hierarchical JSON format (optional)
  hierarchical_JSON <- NULL
  if (!is.null(group1)){
    hierarchical_JSON <- hierarchical_json(dataframe, group1, group2)
  }
  
  # Return results
  list(
    dataframe = dataframe,
    data_JSON = data_JSON,
    hierarchical_JSON = hierarchical_JSON
  )
}

# Function to parse one row
parse_row <- function(line){
  
  fields <- c() # All fields from the current row
  field <- ""   # Current field
  inside_quotes <- FALSE # Track whether the parser is inside quotation marks
  
  # Split the row into individual characters
  chars <- strsplit(line, "")[[1]] 
  
  i <- 1
  while (i <= length(chars)){
    
    char <- chars[i]
    
    if (char == '"'){
      # Handle escaped quotation marks
      if (inside_quotes && i < length(chars) && chars[i + 1] == '"'){
        field <- paste0(field, '"')
        i <- i + 1
      } else{
        # Enter or leave quoted field
        inside_quotes <- !inside_quotes
      }
    } else if (char == "," && !inside_quotes){
      # Comma outside quotes ends a field
      fields <- c(fields, field)
      field <- ""
    } else{
      # Add character to current field
      field <- paste0(field, char)
    }
    
    i <- i + 1
  }
  
  # Check for an unclosed quoted field
  if (inside_quotes) {
    stop("Invalid CSV format: unclosed quoted field.")
  }
  
  # Add the last field
  fields <- c(fields, field)
  
  # Return the parsed fields
  fields
}

# Function to convert data frame to JSON format
data_to_json <- function(data){
  
  json_rows <- c()
  
  for (i in 1:nrow(data)){
    
    fields <- c() # Fields of the current row
    
    # Create one JSON field
    for (j in 1:ncol(data)){
      field <- paste0(
        '    "', names(data)[j], '": "', data[i, j], '"'
      )
      fields <- c(fields, field)
    }
    
    # Combine the fields into one JSON object
    row_json <- paste0(
      " {\n",
      paste(fields, collapse = ",\n"),
      "\n  }"
    )
    json_rows <- c(json_rows, row_json)
  }
  
  # Combine all JSON objects into one JSON array
  json_text <- paste0(
    "[\n",
    paste(json_rows, collapse = ",\n"),
    "\n]"
  )
  
  # Return the JSON text
  json_text
}

# Function to create hierarchical JSON structure
hierarchical_json <- function(data, group1, group2 = NULL) {
  
  # Group the data by the first selected column
  groups1 <- split(data, data[[group1]])
  json_groups1 <- c()
  
  # Loop through the first grouping level
  for (group1_name in names(groups1)) {
    
    data_group1 <- groups1[[group1_name]]
    
    if (is.null(group2)) { # One grouping level
      # Remove the grouping column from the data
      data_rows <- data_group1[names(data_group1) != group1]
      
      # Convert the remaining data to JSON
      rows_json <- data_to_json(data_rows)
      
      # Create one JSON object for the group
      group_json <- paste0(
        '  "', group1_name, '": ',
        rows_json
      )
    } else { # Two grouping levels
      # Group the data by the second selected column
      groups2 <- split(data_group1, data_group1[[group2]])
      json_groups2 <- c()
      
      # Loop through the second grouping level
      for (group2_name in names(groups2)) {
        
        data_group2 <- groups2[[group2_name]]
        
        # Remove the grouping columns from the data
        data_rows <- data_group2[
          , !(names(data_group2) %in% c(group1, group2)),
          drop = FALSE
        ]
        
        # Convert the remaining data to JSON
        rows_json <- data_to_json(data_rows)
        
        # Create one JSON object for the second grouping level
        group2_json <- paste0(
          '      "', group2_name, '": ',
          rows_json
        )
        
        json_groups2 <- c(json_groups2, group2_json)
      }
      
      # Create one JSON object for the first grouping level
      group_json <- paste0(
        "  {\n",
        '    "', group1, '": "', group1_name, '",\n',
        '    "', group2, 's": {\n',
        paste(json_groups2, collapse = ",\n"),
        "\n    }\n",
        "  }"
      )
    }
    
    json_groups1 <- c(json_groups1, group_json)
  }
  
  # Combine all groups into one hierarchical JSON object
  json_text <- paste0(
    "{\n",
    '  "', group1, 's": {\n',
    paste(json_groups1, collapse = ",\n"),
    "\n  }\n",
    "}"
  )
  
  # Return the hierarchical JSON text
  json_text
}
