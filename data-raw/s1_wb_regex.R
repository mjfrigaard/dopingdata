## code to prepare `s1_wb_regex` dataset goes here
load("data/s1_substances.rda")
s1_wb_regex <- paste0("\\b", s1_substances, "\\b", collapse = "|")
usethis::use_data(s1_wb_regex, overwrite = TRUE)
