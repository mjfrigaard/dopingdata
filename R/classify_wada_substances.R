#' Classify banned WADA substances
#'
#' @param usada_data scraped data from USADA website
#' @param subs_column column with substances/reasons for sanctions
#'
#' @return substances dataset with newly classified substances
#' @export
#'
#' @description usada_data should be the table of sanctions from the [United States Anti-Doping Agency](https://www.usada.org/news/sanctions). The `substance_reason` column contains the justification for each sanction. In some cases, there are multiple substances/reasons, and these should be identified first.
#'
#' @examples
#' example_sanction_type
#' substances <- classify_wada_substances(
#'   usada_data = example_sanction_type,
#'   subs_column = substance_reason
#' )
#' head(substances[c('substance_group', 'substance_reason')])
#'
classify_wada_substances <- function(usada_data, subs_column) {
  # Function to classify substance groups based on regex patterns
  classify_group <- function(substance) {
    if (grepl(make_regex(s1_substances), substance)) {
      return("S1 ANABOLIC AGENTS")
    } else if (grepl(make_regex(s2_substances), substance)) {
      return("S2 PEP HORMONES/G FACTORS/MIMETICS")
    } else if (grepl(make_regex(s3_substances), substance)) {
      return("S3 BETA-2 AGONISTS")
    } else if (grepl(make_regex(s4_substances), substance)) {
      return("S4 HORMONE AND METABOLIC MODULATORS")
    } else if (grepl(make_regex(s5_substances), substance)) {
      return("S5 DIURETICS/MASKING AGENTS")
    } else if (grepl(make_regex(m1_method), substance)) {
      return("M1 MANIPULATION OF BLOOD")
    } else if (grepl(make_regex(m2_method), substance)) {
      return("M2 CHEMICAL AND PHYSICAL MANIPULATION")
    } else if (grepl(make_regex(m3_method), substance)) {
      return("M3 GENE AND CELL DOPING")
    } else if (grepl(make_regex(s6_substances), substance)) {
      return("S6 STIMULANTS")
    } else if (grepl(make_regex(s7_substances), substance)) {
      return("S7 NARCOTICS")
    } else if (grepl(make_regex(s8_substances), substance)) {
      return("S8 CANNABINOIDS")
    } else if (grepl(make_regex(s9_substances), substance)) {
      return("S9 GLUCOCORTICOIDS")
    } else if (grepl(make_regex(s0_substances), substance)) {
      return("S0 UNAPPROVED SUBSTANCES")
    } else if (grepl(make_regex(p1_substances), substance)) {
      return("P1 BETA-BLOCKERS")
    } else {
      return("UNCLASSIFIED")
    }
  }
  # browser()
  # Apply the classification function to each row
  usada_data$substance_group <- sapply(usada_data[[subs_column]], classify_group)

  return(usada_data)
}

# classify_wada_substances(
#   usada_data = single_analytic_substances,
#   subs_column = substance_reason)


