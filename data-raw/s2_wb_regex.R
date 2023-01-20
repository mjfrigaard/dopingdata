## code to prepare `s2_wb_regex` dataset goes here
load("data/s2_substances.rda")
s2_wb_regex <- paste0("\\b", s2_substances, "\\b", collapse = "|")
usethis::use_data(s2_wb_regex, overwrite = TRUE)
