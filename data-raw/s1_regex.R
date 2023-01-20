require(stringr)
load("data/s1_substances.rda")
s1_regex <- paste0(s1_substances, collapse = "|")
usethis::use_data(s1_regex, overwrite = TRUE)
