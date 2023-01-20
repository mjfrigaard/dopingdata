## code to prepare `s7_regex` dataset goes here
load("data/s7_substances.rda")
s7_regex <- paste0(s7_substances, collapse = "|")
usethis::use_data(s7_regex, overwrite = TRUE)
