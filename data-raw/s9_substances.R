## code to prepare `s9_substances` dataset goes here
s9_substances <-
  c("betamethasone",
    "budesonide",
    "cortisone",
    "deflazacort",
    "dexamethasone",
    "fluticasone",
    "hydrocortisone",
    "methylprednisolone",
    "prednisolone",
    "prednisone",
    "triamcinolone")
usethis::use_data(s9_substances, overwrite = TRUE)
