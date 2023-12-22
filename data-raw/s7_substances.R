## code to prepare `s7_substances` dataset goes here
s7_substances <-
  c("buprenorphine",
    "dextromoramide",
    "diamorphine (heroin)",
    "fentanyl",
    "hydromorphone",
    "methadone",
    "morphine",
    "nicomorphine",
    "oxycodone",
    "noroxycodone",
    "oxymorphone",
    "pentazocine",
    "pethidine")
usethis::use_data(s7_substances, overwrite = TRUE)
