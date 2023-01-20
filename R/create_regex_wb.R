#' Create a regular expression with word boundaries
#'
#' @param string character vector of items
#'
#' @importFrom stringr str_remove_all
#'
#' @return wb_regex regular expression
#' @export create_regex_wb
#'
#' @examples
#' require(stringr)
#' wb_regex <- create_regex_wb(c("pink", "salmon."))
#' str_view_all(stringr::sentences, wb_regex, match = TRUE)
create_regex_wb <- function(string) {
  lc <- tolower(string)
  punc <- stringr::str_remove_all(lc, "[[:punct:]]+")
  wb_regex <- paste0("\\b", punc, "\\b", collapse = "|")
  return(wb_regex)
}
