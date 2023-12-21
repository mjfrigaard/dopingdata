example_sanction_type <- data.frame(
             sport = c("swimming","track & field",
                       "triathlon","track & field"),
  substance_reason = c("non-analytical: 3 whereabouts failures",
                       "cannabinoids",
                       "androgenic anabolic steroid; cannabinoids",
                       "non-analytical: tampering, administration, and trafficking"))
usethis::use_data(example_sanction_type, overwrite = TRUE)
