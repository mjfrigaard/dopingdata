## code to prepare `s3_substances` dataset goes here
s3_substances <- c("fenoterol",
                  "formoterol",
                  "higenamine",
                  "indacaterol",
                  "non-selective beta-2 agonists",
                  "olodaterol",
                  "optical isomers",
                  "procaterol",
                  "reproterol",
                  "salbutamol",
                  "salmeterol",
                  "selective beta-2 agonists",
                  "terbutaline",
                  "tretoquinol (trimetoquinol)",
                  "tulobuterol",
                  "vilanterol")

usethis::use_data(s3_substances, overwrite = TRUE)
