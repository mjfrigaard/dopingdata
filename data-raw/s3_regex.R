## code to prepare `s3_regex` dataset goes here
load("data/s3_substances.rda")
s3_regex <- paste0(s3_substances, collapse = "|")
usethis::use_data(s3_regex, overwrite = TRUE)
