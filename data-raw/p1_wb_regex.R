## code to prepare `p1_wb_regex` dataset goes here
load("data/p1_substances.rda")
p1_wb_regex <- paste0("\\b", p1_substances, "\\b", collapse = "|")
usethis::use_data(p1_wb_regex, overwrite = TRUE)
