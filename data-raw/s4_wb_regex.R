## code to prepare `s4_wb_regex` dataset goes here
load("data/s4_substances.rda")
s4_wb_regex <- paste0("\\b", s4_substances, "\\b", collapse = "|")
usethis::use_data(s4_wb_regex, overwrite = TRUE)
