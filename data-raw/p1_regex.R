## code to prepare `p1_regex` dataset goes here
load("data/p1_substances.rda")
p1_regex <- paste0(p1_substances, collapse = "|")
usethis::use_data(p1_regex, overwrite = TRUE)
