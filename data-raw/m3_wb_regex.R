## code to prepare `m3_wb_regex` dataset goes here
load("data/m3_method.rda")
m3_wb_regex <- paste0("\\b", m3_method, "\\b", collapse = "|")
usethis::use_data(m3_wb_regex, overwrite = TRUE)
