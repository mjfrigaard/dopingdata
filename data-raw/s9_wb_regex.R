## code to prepare `s9_wb_regex` dataset goes here
load("data/s9_substances.rda")
s9_wb_regex <- paste0("\\b", s9_substances, "\\b", collapse = "|")
usethis::use_data(s9_wb_regex, overwrite = TRUE)
