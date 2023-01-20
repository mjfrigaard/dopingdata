## code to prepare `m2_wb_regex` dataset goes here
load("data/m2_method.rda")
m2_wb_regex <- paste0("\\b", m2_method, "\\b", collapse = "|")
usethis::use_data(m2_wb_regex, overwrite = TRUE)
