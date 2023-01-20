## code to prepare `m1_regex` dataset goes here
load("data/m1_method.rda")
m1_regex <- paste0(m1_method, collapse = "|")
usethis::use_data(m1_regex, overwrite = TRUE)
