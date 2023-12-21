#' Re-classify a specific WADA substance
#'
#' @param df data from USADA website
#' @param substance character string of banned WADA substances
#' @param value character string of substance group value
#' @param substance_col column with substances/reasons for sanctions (assumes
#'   it's `substance_reason`).
#' @param wb logical, include word boundary?
#'
#'
#' @return substance dataset with newly classified substances
#' @export reclass_substance
#'
reclass_substance <- function(df, substance, value, substance_col = "substance_reason", wb = FALSE) {
  if (wb == TRUE) {
    subs_regex <- create_word_boundary(substance)
  } else {
    subs_regex <- paste0(substance, collapse = "|")
  }

  # Applying the regex to the specified column and updating the 'substance_group' column
  df$substance_group <- ifelse(grepl(subs_regex, df[[substance_col]]), value, df$substance_group)

  return(df)
}
