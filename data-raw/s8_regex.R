## code to prepare `s8_regex` dataset goes here
load("data/s8_substances.rda")
s8_regex <- paste0(s8_substances, collapse = "|")
usethis::use_data(s8_regex, overwrite = TRUE)
