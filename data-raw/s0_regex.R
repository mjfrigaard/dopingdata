## code to prepare `s0_regex` dataset goes here
load("data/s0_substances.rda")
s0_regex <- paste0(s0_substances, collapse = "|")
usethis::use_data(s0_regex, overwrite = TRUE)
