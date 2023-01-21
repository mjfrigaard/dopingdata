#' Classify a specific WADA substance
#'
#' @param df data from USADA website
#' @param subs_col column with substances/reasons for sanctions
#' @param subs character string of banned WADA substances
#' @param var name of new variable
#' @param val variable value when matched
#' @param wb include word boundary
#'
#' @importFrom dplyr mutate
#' @importFrom dplyr case_when
#' @importFrom stringr str_detect
#'
#' @return substance dataset with newly classified substances
#' @export classify_substance
#'
classify_substance <- function(df, subs_col, subs, var, val = "match", wb = TRUE) {
  if (wb == TRUE) {
    subs_regex <- create_regex_wb(subs)
  } else {
    subs_regex <- paste0(subs, collapse = "|")
  }
  col_index <- length(colnames(df)) + 1

  substance <- dplyr::mutate(
    .data = df,
    var = dplyr::case_when(
      stringr::str_detect({{ subs_col }}, subs_regex) ~ val,
      TRUE ~ NA_character_
    )
  )

  colnames(substance)[col_index] <- var

  return(substance)
}

