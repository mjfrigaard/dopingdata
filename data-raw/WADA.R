## code to prepare `WADA` dataset goes here
require(readxl)
require(stringr)
require(dplyr)
require(tibble)
require(purrr)
# import xlsx sheet of wada list substances
pth <- "inst/extdata/wada/wada-2019-english-prohibited-list.xlsx"
all_sheets <- pth |>
  readxl::excel_sheets() |>
  purrr::set_names() |>
  purrr::map(readxl::read_excel, path = pth)
sheet_nms <- names(all_sheets)
# sheet_nms |> writeLines()
# S1 ANABOLIC AGENTS
s1 <- all_sheets[["S1 ANABOLIC AGENTS"]] |>
  purrr::set_names("substance", "type")
# S2 PH, GF, RS, MIMETICS
s2 <- all_sheets[["S2 PH, GF, RS, MIMETICS"]] |>
  purrr::set_names("substance", "type")

# S3 BETA-2 AGONISTS
s3 <- all_sheets[["S3 BETA-2 AGONISTS"]] |>
  purrr::set_names("substance", "type")

# S4 HORMONE AND METABOLIC MOD.
s4 <- all_sheets[["S4 HORMONE AND METABOLIC MOD."]] |>
  purrr::set_names("substance", "type")

# S5 DIURETICS AND MASKING AGENTS
s5 <- all_sheets[["S5 DIURETICS AND MASKING AGENTS"]] |>
  purrr::set_names("substance", "type")

# S6 STIMULANTS
s6 <- all_sheets[["S6 STIMULANTS"]] |>
  purrr::set_names("substance", "type")
s6
# S7 NARCOTICS
s7 <- all_sheets[["S7 NARCOTICS"]] |>
  purrr::set_names("substance", "type")

# S8 CANNABINOIDS
s8 <- all_sheets[["S8 CANNABINOIDS"]] |>
  purrr::set_names("substance", "type")
s8
# S9 GLUCOCORTICOIDS
s9 <- all_sheets[["S9 GLUCOCORTICOIDS"]] |>
  purrr::set_names("substance", "type")

# P1 BETA-BLOCKERS
p1 <- all_sheets[["P1 BETA-BLOCKERS"]] |>
  purrr::set_names("substance", "type")

# M1 MANIPULATION OF BLOOD
m1 <- all_sheets[["M1 MANIPULATION OF BLOOD"]] |>
  purrr::set_names("substance", "type")

# M2 CHEMICAL AND PHYSICAL MANIP
m2 <- all_sheets[["M2 CHEMICAL AND PHYSICAL MANIP"]] |>
  purrr::set_names("substance", "type")

# M3 GENE AND CELL DOPING
m3 <- all_sheets[["M3 GENE AND CELL DOPING"]] |>
  purrr::set_names("substance", "type")

# sheet_nms |> dput()

WADA <- dplyr::bind_rows(
  "S1 ANABOLIC AGENTS" = s1,
  "S2 PH, GF, RS, MIMETICS" = s2,
  "S3 BETA-2 AGONISTS" = s3,
  "S4 HORMONE AND METABOLIC MOD." = s4,
  "S5 DIURETICS AND MASKING AGENTS" = s5,
  "S6 STIMULANTS" = s6,
  "S7 NARCOTICS" = s7,
  "S8 CANNABINOIDS" = s8,
  "S9 GLUCOCORTICOIDS" = s9,
  "P1 BETA-BLOCKERS" = p1,
  "M1 MANIPULATION OF BLOOD" = m1,
  "M2 CHEMICAL AND PHYSICAL MANIP" = m2,
  "M3 GENE AND CELL DOPING" = m3,
  .id = "groups")

# WADA |> count(type)

usethis::use_data(WADA, overwrite = TRUE)
