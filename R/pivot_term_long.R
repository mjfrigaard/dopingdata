#' Parse string into individual terms
#'
#' @param term A character vector of one or more strings to parse.
#' @param sep A regular expression used to split each string into terms.
#'   Defaults to `"[^[:alnum:]]+"` (any run of non-alphanumeric characters).
#'
#' @return A data.frame with two columns: `unique_items` (individual terms
#'   split from the input) and `term` (the original input string, repeated
#'   in the first row of each group with `NA` for subsequent rows).
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
