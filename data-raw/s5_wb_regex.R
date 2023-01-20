## code to prepare `s5_wb_regex` dataset goes here
load("data/s5_substances.rda")
s5_wb_regex <- paste0("\\b", s5_substances, "\\b", collapse = "|")
usethis::use_data(s5_wb_regex, overwrite = TRUE)
