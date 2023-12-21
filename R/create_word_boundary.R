#' Create a regular expression with word boundaries
#'
#' @param string character vector of items
#'
#'
#' @return wb_regex regular expression
#' @export create_word_boundary
#'
#' @examples
#' require(stringr)
#' wb_regex <- create_word_boundary(c("pink", "salmon."))
#' str_view(stringr::sentences, wb_regex, match = TRUE)
create_word_boundary <- function(string) {
  lc <- tolower(string)
  punc <- gsub("[[:punct:]]+", "", lc)
  wb_regex <- paste0("\\b", punc, "\\b", collapse = "|")
  return(wb_regex)
}
