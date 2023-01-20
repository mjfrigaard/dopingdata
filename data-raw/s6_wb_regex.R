## code to prepare `s6_wb_regex` dataset goes here
load("data/s6_substances.rda")
s6_wb_regex <- paste0("\\b", s6_substances, "\\b", collapse = "|")
usethis::use_data(s6_wb_regex, overwrite = TRUE)
