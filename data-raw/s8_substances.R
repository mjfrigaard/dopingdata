## code to prepare `s8_substances` dataset goes here
s8_substances <-
  c("cannabimimetics",
    "cannabinoids",
    "cannabis",
    "hashish",
    "marijuana",
    "natural cannabinoids",
    "synthetic cannabinoids",
    "δ9-tetrahydrocannabinol (thc)")
usethis::use_data(s8_substances, overwrite = TRUE)
