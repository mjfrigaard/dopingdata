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
    if (grepl(s1_regex, substance)) {
      return("S1 ANABOLIC AGENTS")
    } else if (grepl(s2_regex, substance)) {
      return("S2 PEP HORMONES/G FACTORS/MIMETICS")
    } else if (grepl(s3_regex, substance)) {
      return("S3 BETA-2 AGONISTS")
    } else if (grepl(s4_regex, substance)) {
      return("S4 HORMONE AND METABOLIC MODULATORS")
    } else if (grepl(s5_regex, substance)) {
      return("S5 DIURETICS/MASKING AGENTS")
    } else if (grepl(m1_regex, substance)) {
      return("M1 MANIPULATION OF BLOOD")
    } else if (grepl(m2_regex, substance)) {
      return("M2 CHEMICAL AND PHYSICAL MANIPULATION")
    } else if (grepl(m3_regex, substance)) {
      return("M3 GENE AND CELL DOPING")
    } else if (grepl(s6_regex, substance)) {
      return("S6 STIMULANTS")
    } else if (grepl(s7_regex, substance)) {
      return("S7 NARCOTICS")
    } else if (grepl(s8_regex, substance)) {
      return("S8 CANNABINOIDS")
    } else if (grepl(s9_regex, substance)) {
      return("S9 GLUCOCORTICOIDS")
    } else if (grepl(s0_regex, substance)) {
      return("S0 UNAPPROVED SUBSTANCES")
    } else if (grepl(p1_regex, substance)) {
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


