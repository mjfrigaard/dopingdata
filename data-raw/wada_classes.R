## code to prepare `wada_classes` dataset goes here
require(tibble)
wada_classes <- tibble::tribble(
  ~ Classification,
  "S1 ANABOLIC AGENTS",
  "S2 PEP HORMONES/G FACTORS/MIMETICS",
  "S3 BETA-2 AGONISTS",
  "S4 HORMONE AND METABOLIC MODULATORS",
  "S5 DIURETICS/MASKING AGENTS",
  "S6 STIMULANTS",
  "S7 NARCOTICS",
  "S8 CANNABINOIDS",
  "S9 GLUCOCORTICOIDS",
  "M1 MANIPULATION OF BLOOD",
  "M2 CHEMICAL AND PHYSICAL MANIPULATION",
  "M3 GENE AND CELL DOPING",
  "P1 BETA-BLOCKERS")
usethis::use_data(wada_classes, overwrite = TRUE)
