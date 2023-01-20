## code to prepare `s6_regex` dataset goes here
load("data/s6_substances.rda")
s6_regex <- paste0(s6_substances, collapse = "|")
usethis::use_data(s6_regex, overwrite = TRUE)
