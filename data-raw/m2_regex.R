## code to prepare `m2_regex` dataset goes here
load("data/m2_method.rda")
m2_regex <- paste0(m2_method, collapse = "|")
usethis::use_data(m2_regex, overwrite = TRUE)
