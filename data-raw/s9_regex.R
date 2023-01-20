## code to prepare `s9_regex` dataset goes here
load("data/s9_substances.rda")
s9_regex <- paste0(s9_substances, collapse = "|")
usethis::use_data(s9_regex, overwrite = TRUE)
