## code to prepare `s7_wb_regex` dataset goes here
load("data/s7_substances.rda")
s7_wb_regex <- paste0("\\b", s7_substances, "\\b", collapse = "|")
usethis::use_data(s7_wb_regex, overwrite = TRUE)
