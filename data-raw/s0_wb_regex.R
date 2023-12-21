## code to prepare `s0_wb_regex` dataset goes here
load("data/s0_substances.rda")
s0_wb_regex <- paste0("\\b", s0_substances, "\\b", collapse = "|")
usethis::use_data(s0_wb_regex, overwrite = TRUE)
