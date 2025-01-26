# Install required packages if not already installed
if (!require("httr")) install.packages("httr")
if (!require("readr")) install.packages("readr")
if (!require("dplyr")) install.packages("dplyr")
if (!require("tidyr")) install.packages("tidyr")
if (!require("tibble")) install.packages("tibble")

# Load libraries
library(httr)
library(readr)
library(dplyr)
library(tidyr)
library(tibble)

# Fetch the CSV content and read into data frames
interactions <- read_csv(content(GET("https://docs.google.com/spreadsheets/d/1nbn86nLAy5dOtsxPoD8CXzbeNdn892rsLUyIbXZhaXE/export?format=csv&gid=233723893"), "text"), show_col_types = FALSE)
facility_info <- read_csv(content(GET("https://docs.google.com/spreadsheets/d/1nbn86nLAy5dOtsxPoD8CXzbeNdn892rsLUyIbXZhaXE/export?format=csv&gid=200201008"), "text"), show_col_types = FALSE)
personnel <- read_csv(content(GET("https://docs.google.com/spreadsheets/d/1nbn86nLAy5dOtsxPoD8CXzbeNdn892rsLUyIbXZhaXE/export?format=csv&gid=942158341"), "text"), show_col_types = FALSE)
employee_lookup <- read_csv(content(GET("https://docs.google.com/spreadsheets/d/1nbn86nLAy5dOtsxPoD8CXzbeNdn892rsLUyIbXZhaXE/export?format=csv&gid=1811056208"), "text"), show_col_types = FALSE)

# Step 1: Join interactions with personnel on shift_name and shift_id
interactions_with_personnel <- interactions %>%
  left_join(personnel, by = c("Shift_name" = "Shift_id"))

#Step 2: Join employee lookup info
final_data <- interactions_with_personnel %>%
  left_join(employee_lookup, by = c("Employee_id" = "ID"))

#Step 3: I give the tie-breaker to the responsible physician with the most tenure
# Flag the most tenured employee per shift_id
final_data <- final_data %>%
  group_by(Shift_name) %>%                             # Group by shift_id
  mutate(most_tenured_flag = ifelse(tenure == max(tenure, na.rm = TRUE), TRUE, FALSE)) %>% 
  ungroup()  

#Step 4: Most Tenured
# Filter to keep only rows where most_tenured_flag is TRUE
final_data_most_tenured <- final_data %>%
  filter(most_tenured_flag == TRUE)

#Step 5: keep the first on any remaining ties
final_data_cleaned <- final_data_most_tenured %>%
  group_by(patient_id, Shift_name) %>%
  arrange(Date, Time) %>% # Ensures the first record is based on earliest time
  slice(1) %>% # Keeps only the first record for each combination
  ungroup()

# Finally, create the crosstab with grouping fixed
crosstab <- final_data_cleaned %>%
group_by(Name, Admitted) %>%
summarize(patient_count = n_distinct(patient_id), .groups = "drop") %>% # Add .groups = "drop" to avoid grouping issues
pivot_wider(names_from = Admitted, values_from = patient_count, values_fill = list(patient_count = 0)) # Spread admitted values

rm(employee_lookup, facility_info, final_data, final_data_most_tenured, interactions, interactions_with_personnel, personnel)
View(final_data_cleaned)
View(crosstab)


