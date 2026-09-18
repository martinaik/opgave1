# Test the CSV parser

library(testthat)

source("parse_csv.R")

# Test that a simple CSV file is parsed into the correct data frame.
test_that("Parses a simple CSV correctly", {
  
  csv_text <- "name,email
Anna,anna@example.com
Peter,peter@example.com"
  
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
Anna,anna@example.com"
  
  writeLines(csv_text, "one_row.csv")
  
  result <- parse_csv("one_row.csv")
  
  expect_equal(nrow(result$dataframe), 1)
  expect_equal(result$dataframe$name[1], "Anna")
  expect_equal(result$dataframe$email[1], "anna@example.com")
})

# Test that empty fields are preserved during parsing.
test_that("Parses empty fields", {
  
  csv_text <- "name,email
Anna,
Peter,peter@example.com"
  
  writeLines(csv_text, "missing.csv")
  
  result <- parse_csv("missing.csv")
  
  expect_equal(result$dataframe$email[1], "")
  expect_equal(result$dataframe$email[2], "peter@example.com")
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
Anna,"San Francisco, CA"'
  
  writeLines(csv_text, "quoted.csv")
  
  result <- parse_csv("quoted.csv")
  
  expect_equal(result$dataframe$office[1], "San Francisco, CA")
})

# Test that the parser returns an error when a row has too many fields.
test_that("Error if a row has too many fields", {
  
  csv_text <- "name,email
Anna,anna@example.com,extra"
  
  writeLines(csv_text, "too_many.csv")
  
  expect_error(parse_csv("too_many.csv"))
})

# Test that the parser returns an error when a row has too few fields
test_that("Error if a row has too few fields", {
  
  csv_text <- "name,email,department
Anna,anna@example.com"
  
  writeLines(csv_text, "too_few.csv")
  
  expect_error(parse_csv("too_few.csv"))
})

# Test that Danish characters are preserved during parsing
test_that("Preserves Danish characters", {
  
  csv_text <- "navn
Helligånds"
  
  writeLines(csv_text, "danish.csv")
  
  result <- parse_csv("danish.csv")
  
  expect_equal(result$dataframe$navn[1], "Helligånds")
})

# Test that a CSV file with a blank last line is parsed correctly.
test_that("Ignores blank last line", {
  
  csv_text <- "name,email
Anna,anna@example.com
"
  
  writeLines(csv_text, "blank_line.csv")
  
  result <- parse_csv("blank_line.csv")
  
  expect_equal(nrow(result$dataframe), 1)
})

# Test that an empty CSV file returns an error.
test_that("Error with empty CSV file", {
  
  writeLines("", "empty.csv")
  
  expect_error(parse_csv("empty.csv"))
})

# Test that escaped quotation marks are parsed correctly.
test_that("Parses escaped quotation mark", {
  
  csv_text <- 'name,comment
Anna,"He said ""Hello"""'
  
  writeLines(csv_text, "quotes.csv")
  
  result <- parse_csv("quotes.csv")
  
  expect_equal(result$dataframe$comment[1], 'He said "Hello"')
})

# Test that the parser also returns a valid JSON representation.
test_that("JSON output is being created", {
  
  csv_text <- "name,email
Anna,anna@example.com"
  
  writeLines(csv_text, "json.csv")
  
  result <- parse_csv("json.csv")
  
  expect_true(is.character(result$data_JSON))
  expect_true(grepl("Anna", result$data_JSON))
})

