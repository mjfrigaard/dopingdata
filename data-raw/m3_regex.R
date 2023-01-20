## code to prepare `m3_regex` dataset goes here
load("data/m3_method.rda")
m3_regex <- paste0(m3_method, collapse = "|")
usethis::use_data(m3_regex, overwrite = TRUE)
