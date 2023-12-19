#' Create column with matched value
#'
#' @param string string to search
#' @param pattern regex pattern to match
#'
#' @return matched string
#'
#' @export
#'
#' @examples
#' require(dplyr)
#' require(tidyr)
#' dplyr::mutate(head(dplyr::starwars),
#'       match = add_match_col(name, "Skywalker")) |>
#'   dplyr::select(name, last_col())
add_match_col <- function(string, pattern) {

  match_terms <- regmatches(string, gregexpr(pattern, string))

  max_len <- max(sapply(match_terms, length))
  match_matrix <- t(sapply(match_terms, function(x) {
    c(x, rep("", max_len - length(x)))
  }))

  match_df <- as.data.frame(t(match_matrix), stringsAsFactors = FALSE)

  if (ncol(match_df) > 0) {
    match_combined <- apply(X = match_df, MARGIN = 1, FUN = function(x) {
      trimws(paste(na.omit(x), collapse = ", "), which = "right")
    })
  } else {
    match_combined <- rep(NA_character_, nrow(match_df))
  }

  match_combined[match_combined == ""] <- NA

  return(match_combined)
}
