tv_classify_wada_substances <- function(usada_data, subs_column) {
    # case_when for substance_group
    substances <- dplyr::mutate(
      .data = usada_data,
      substance_group = dplyr::case_when(
        stringr::str_detect({{ subs_column }}, s1_regex) ~ "S1 ANABOLIC AGENTS",
        stringr::str_detect({{ subs_column }}, s2_regex) ~ "S2 PEP HORMONES/G FACTORS/MIMETICS",
        stringr::str_detect({{ subs_column }}, s3_regex) ~ "S3 BETA-2 AGONISTS",
        stringr::str_detect({{ subs_column }}, s4_regex) ~ "S4 HORMONE AND METABOLIC MODULATORS",
        stringr::str_detect({{ subs_column }}, s5_regex) ~ "S5 DIURETICS/MASKING AGENTS",
        stringr::str_detect({{ subs_column }}, m1_regex) ~ "M1 MANIPULATION OF BLOOD",
        stringr::str_detect({{ subs_column }}, m2_regex) ~ "M2 CHEMICAL AND PHYSICAL MANIPULATION",
        stringr::str_detect({{ subs_column }}, m3_regex) ~ "M3 GENE AND CELL DOPING",
        stringr::str_detect({{ subs_column }}, s6_regex) ~ "S6 STIMULANTS",
        stringr::str_detect({{ subs_column }}, s7_regex) ~ "S7 NARCOTICS",
        stringr::str_detect({{ subs_column }}, s8_regex) ~ "S8 CANNABINOIDS",
        stringr::str_detect({{ subs_column }}, s9_regex) ~ "S9 GLUCOCORTICOIDS",
        stringr::str_detect({{ subs_column }}, p1_regex) ~ "P1 BETA-BLOCKERS",
        TRUE ~ "UNCLASSIFIED"
      )
    )
    return(substances)
  }
