## code to prepare `s8_wb_regex` dataset goes here
load("data/s8_substances.rda")
s8_wb_regex <- paste0("\\b", s8_substances, "\\b", collapse = "|")
usethis::use_data(s8_wb_regex, overwrite = TRUE)
