#' Classify a specific WADA substance
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
#' @export classify_substance
#'
classify_substance <- function(df, substance, value, substance_col = "substance_reason", wb = FALSE) {
  if (wb == TRUE) {
    subs_regex <- create_regex_wb(substance)
  } else {
    subs_regex <- paste0(substance, collapse = "|")
  }

  substance <- dplyr::mutate(
    .data = df,
    substance_group = dplyr::case_when(
      stringr::str_detect(.data[[substance_col]], subs_regex) ~  value,
      TRUE ~ substance_group
    )
  )

  return(substance)
}
