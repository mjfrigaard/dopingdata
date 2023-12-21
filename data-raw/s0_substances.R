## code to prepare `s0_substances` dataset goes here
s0_substances <-
  c(
    # bpc-157 ----
    # https://www.usada.org/spirit-of-sport/education/bpc-157-peptide-prohibited/
    "bpc-157"
    )
usethis::use_data(s0_substances, overwrite = TRUE)
