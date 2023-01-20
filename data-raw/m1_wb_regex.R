## code to prepare `m1_wb_regex` dataset goes here
load("data/m1_method.rda")
m1_wb_regex <- paste0("\\b", m1_method, "\\b", collapse = "|")
usethis::use_data(m1_wb_regex, overwrite = TRUE)
