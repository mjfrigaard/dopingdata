## code to prepare `s2_regex` dataset goes here
load("data/s2_substances.rda")
s2_regex <- paste0(s2_substances, collapse = "|")
usethis::use_data(s2_regex, overwrite = TRUE)
