library(tidyverse)

df <- read_csv('data/wideFormatTimeData_antoni.csv')
# Fix the incorrect names
colnames(df) <- str_replace(colnames(df), '_32', '_30')

for(day in 1:2){
  r_col_detector <- c(
    # Take the universally needed values
    colnames(df)[1:4],
    # Create a vector of hour time endings for day 1
    str_c('_', as.character(1:4*6 + (day-1)*24))
  ) %>% 
    str_c('(', . , '$)', collapse = '|')
  
  col_names <- grep(r_col_detector, colnames(df), value = TRUE)
  
  if(day == 1) {
    # Save these column names for later use
    day_1_col_names <- col_names
    day_1_res <- df[, day_1_col_names]
    day_1_res$day <- 0
  } else {
    day_2_res <- df[, col_names]
    colnames(day_2_res) <- day_1_col_names
    day_2_res$day <- 1
    res <- bind_rows(day_1_res, day_2_res)
  }
}

write_rds(res, 'results')
