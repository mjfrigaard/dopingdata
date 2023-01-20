## code to prepare `m2_method` dataset goes here
m2_method <-
  c("alter",
    "altering",
    "attempting to alter",
    "attempting to tamper",
    "intravenous infusions and/or injections",
    "proteases",
    "tamper",
    "tampering",
    "urine substitution and/or adulteration")
usethis::use_data(m2_method, overwrite = TRUE)
