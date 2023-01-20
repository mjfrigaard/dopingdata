## code to prepare `s3_wb_regex` dataset goes here
load("data/s3_substances.rda")
s3_wb_regex <- paste0("\\b", s3_substances, "\\b", collapse = "|")
usethis::use_data(s3_wb_regex, overwrite = TRUE)
