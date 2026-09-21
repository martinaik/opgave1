# Test the CSV parser

library(testthat)

source("parse_csv.R")

# Test that a simple CSV file is parsed into the correct data frame.
test_that("Parses a simple CSV correctly", {
  
  csv_text <- "name,email
Marcus,marcus.chen@example.com
Priya,priya.sharma@example.com"
  
  writeLines(csv_text, "test.csv")
  
  result <- parse_csv("test.csv")
  
  expect_equal(nrow(result$dataframe), 2)
  expect_equal(ncol(result$dataframe), 2)
  expect_equal(names(result$dataframe), c("name", "email"))
})

# Test that the provided employees.ascii.csv file is parsed correctly.
test_that("Parses employees.ascii.csv correctly", {
  
  result <- parse_csv("employees.ascii.csv")
  
  expect_equal(nrow(result$dataframe), 30)
  expect_equal(ncol(result$dataframe), 7)
})

# Test that the provided sogne.dawa.csv file is parsed correctly.
test_that("Parses sogne.dawa.csv correctly", {
  
  result <- parse_csv("sogne.dawa.csv")
  
  expect_equal(nrow(result$dataframe), 2097)
  expect_equal(ncol(result$dataframe), 12)
})

# Test a CSV file that contains only a header row and no data rows.
test_that("Parses a CSV file with only a header", {
  
  csv_text <- "name,email,department"
  writeLines(csv_text, "header_only.csv")
  
  result <- parse_csv("header_only.csv")
  
  expect_equal(nrow(result$dataframe), 0)
  expect_equal(ncol(result$dataframe), 3)
})

# Test a CSV file with only one data row.
test_that("Parses a file with one data row", {
  
  csv_text <- "name,email
Marcus,marcus.chen@example.com"
  
  writeLines(csv_text, "one_row.csv")
  
  result <- parse_csv("one_row.csv")
  
  expect_equal(nrow(result$dataframe), 1)
  expect_equal(result$dataframe$name[1], "Marcus")
  expect_equal(result$dataframe$email[1], "marcus.chen@example.com")
})

# Test a CSV file with only one column.
test_that("Parses a file with one column", {
  
  csv_text <- "name
Marcus
Priya"
  
  writeLines(csv_text, "one_column.csv")
  
  result <- parse_csv("one_column.csv")
  
  expect_equal(ncol(result$dataframe), 1)
  expect_equal(nrow(result$dataframe), 2)
})

# Test that the parser returns an error when a row has too many fields.
test_that("Error if a row has too many fields", {
  
  csv_text <- "name,email
Marcus,marcus.chen@example.com,extra"
  
  writeLines(csv_text, "too_many.csv")
  
  expect_error(parse_csv("too_many.csv"))
})

# Test that the parser returns an error when a row has too few fields
test_that("Error if a row has too few fields", {
  
  csv_text <- "name,email,department
Marcus,marcus.chen@example.com"
  
  writeLines(csv_text, "too_few.csv")
  
  expect_error(parse_csv("too_few.csv"))
})

# Test that empty fields are preserved during parsing.
test_that("Parses empty fields", {
  
  csv_text <- "name,email
Marcus,
Priya,priya.sharma@example.com"
  
  writeLines(csv_text, "missing.csv")
  
  result <- parse_csv("missing.csv")
  
  expect_equal(result$dataframe$email[1], "")
  expect_equal(result$dataframe$email[2], "priya.sharma@example.com")
})

# Test that multiple empty fields are preserved during parsing.
test_that("Parses multiple empty fields", {
  
  csv_text <- "name,email,office
Marcus,,London
Priya,priya.sharma@example.com,"
  
  writeLines(csv_text, "multiple_missing.csv")
  
  result <- parse_csv("multiple_missing.csv")
  
  expect_equal(result$dataframe$email[1], "")
  expect_equal(result$dataframe$office[2], "")
})

# Test that spaces inside fields are preserved.
test_that("Preserves spaces inside fields", {
  
  csv_text <- "name,office
Marcus Chen,San Francisco"
  
  writeLines(csv_text, "spaces.csv")
  
  result <- parse_csv("spaces.csv")
  
  expect_equal(result$dataframe$name[1], "Marcus Chen")
  expect_equal(result$dataframe$office[1], "San Francisco")
})

# Test that a comma inside a quoted field is treated as part of the field
test_that("Parses comma in quoted field", {
  
  csv_text <- 'name,office
Marcus,"San Francisco, CA"'
  
  writeLines(csv_text, "quoted.csv")
  
  result <- parse_csv("quoted.csv")
  
  expect_equal(result$dataframe$office[1], "San Francisco, CA")
})

# Test that a field containing both commas and quotation marks is parsed correctly.
test_that("Parses a field containing both commas and quotation marks", {
  
  csv_text <- 'name,comment
Marcus,"He said ""Hello, Marcus"""'
  
  writeLines(csv_text, "complex_quotes.csv")
  
  result <- parse_csv("complex_quotes.csv")
  
  expect_equal(result$dataframe$comment[1], 'He said "Hello, Marcus"')
})

# Test that escaped quotation marks are parsed correctly.
test_that("Parses escaped quotation mark", {
  
  csv_text <- 'name,comment
Marcus,"He said ""Hello"""'
  
  writeLines(csv_text, "quotes.csv")
  
  result <- parse_csv("quotes.csv")
  
  expect_equal(result$dataframe$comment[1], 'He said "Hello"')
})

# Test that an unclosed quoted field returns an error.
test_that("Returns an error for an unclosed quoted field", {
  
  csv_text <- 'name,comment
Marcus,"Hello'
  
  writeLines(csv_text, "unclosed_quotes.csv")
  
  expect_error(parse_csv("unclosed_quotes.csv"))
})

# Test that an empty quoted field is parsed correctly.
test_that("Parses empty quoted field", {
  
  csv_text <- 'name,email
Marcus,""'
  
  writeLines(csv_text, "empty_quotes.csv")
  
  result <- parse_csv("empty_quotes.csv")
  
  expect_equal(result$dataframe$email[1], "")
})

# Test that Danish characters are preserved during parsing
test_that("Preserves Danish characters", {
  
  csv_text <- "navn
Helligånds"
  
  writeLines(csv_text, "danish.csv")
  
  result <- parse_csv("danish.csv")
  
  expect_equal(result$dataframe$navn[1], "Helligånds")
})

# Test that special characters are preserved during parsing.
test_that("Parses special characters", {
  
  csv_text <- "name,comment
Marcus,Hello! #2026"
  
  writeLines(csv_text, "special.csv")
  
  result <- parse_csv("special.csv")
  
  expect_equal(result$dataframe$comment[1], "Hello! #2026")
})

# Test that numeric values are parsed as text.
test_that("Parses numeric values as text", {
  
  csv_text <- "salary
155000"
  
  writeLines(csv_text, "numbers.csv")
  
  result <- parse_csv("numbers.csv")
  
  expect_equal(result$dataframe$salary[1], "155000")
})

# Test that a CSV file with a blank last line is parsed correctly.
test_that("Ignores blank last line", {
  
  csv_text <- "name,email
Marcus,marcus.chen@example.com
"
  
  writeLines(csv_text, "blank_line.csv")
  
  result <- parse_csv("blank_line.csv")
  
  expect_equal(nrow(result$dataframe), 1)
})

# Test an empty row in the middle of the file returns an error
test_that("Returns an error for an empty row in the middle of the file", {
  
  csv_text <- "name,email
Marcus,marcus.chen@example.com

Priya,priya.sharma@example.com"
  
  writeLines(csv_text, "blank_middle.csv")
  
  expect_error(parse_csv("blank_middle.csv"))
})

# Test that an empty CSV file returns an error.
test_that("Returns an error for an empty CSV file", {
  
  writeLines("", "empty.csv")
  
  expect_error(parse_csv("empty.csv"))
})

# Test that the parser returns a valid JSON representation.
test_that("JSON output is being created", {
  
  csv_text <- "name,email
Marcus,marcus.chen@example.com"
  
  writeLines(csv_text, "json.csv")
  
  result <- parse_csv("json.csv")
  
  expect_true(is.character(result$data_JSON))
  expect_true(grepl("Marcus", result$data_JSON))
})

# Test that the JSON output contains all column names.
test_that("JSON contains all column names", {
  
  csv_text <- "name,email
Anna,anna@example.com"
  
  writeLines(csv_text, "json_columns.csv")
  
  result <- parse_csv("json_columns.csv")
  
  expect_true(grepl('"name"', result$data_JSON))
  expect_true(grepl('"email"', result$data_JSON))
})