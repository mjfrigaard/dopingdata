## code to prepare `s5_regex` dataset goes here
load("data/s5_substances.rda")
s5_regex <- paste0(s5_substances, collapse = "|")
usethis::use_data(s5_regex, overwrite = TRUE)
