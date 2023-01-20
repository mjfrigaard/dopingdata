## code to prepare `s4_regex` dataset goes here
load("data/s4_substances.rda")
s4_regex <- paste0(s4_substances, collapse = "|")
usethis::use_data(s4_regex, overwrite = TRUE)
