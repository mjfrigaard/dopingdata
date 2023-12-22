#' Create a Regular Expression Pattern
#'
#' `make_regex()` takes a character vector and returns a regular expression pattern.
#' If `wb` is `TRUE`, word boundaries (`\\b`) are added before and after each element.
#'
#' @param x A character vector to be converted into a regular expression.
#' @param wb Logical; if `TRUE`, adds word boundaries around each element of `x`.
#'
#' @return A character string containing the regular expression pattern.
#'
#' @export
#'
#' @examples
#' make_regex(c("apple", "banana"))
#' make_regex(c("cat", "dog"), wb = FALSE)
make_regex <- function(x, wb = FALSE) {
  stopifnot(exprs = {
    is.character(x)
  })
  if (wb) {
    paste0(x, collapse = "|")
  } else {
    paste0("\\b", x, "\\b", collapse = "|")
  }
}
