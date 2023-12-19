#' Parse string into individual terms (as tibble)
#'
#' @param term
#'
#' @return tibble of unique terms and term
#' @export
#'
#' @examples
#' pivot_term_long(term = "A large size in stockings is hard to sell.")
pivot_term_long <- function(term, sep = "[^[:alnum:]]+") {

  pivot_term <- function(term, sep) {
      term_items <- unlist(strsplit(term, sep))
      term_col <- c(term, rep(NA_character_, times = length(term_items) - 1))
      data.frame(unique_items = term_items, term = term_col)
  }

  if (length(term) > 1) {
    do.call(rbind, lapply(term, pivot_term, sep = sep))
  } else {
    pivot_term(term = term, sep = sep)
  }

}
