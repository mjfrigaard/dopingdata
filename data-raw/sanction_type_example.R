sanction_type_example <- data.frame(
             sport = c("swimming","track & field",
                       "triathlon","track & field"),
  substance_reason = c("non-analytical: 3 whereabouts failures",
                       "cannabinoids",
                       "androgenic anabolic steroid; cannabinoids",
                       "non-analytical: tampering, administration, and trafficking"),
     sanction_type = c("non-analytical","analytical",
                       "analytical","non-analytical"))
usethis::use_data(sanction_type_example, overwrite = TRUE)
