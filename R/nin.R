# `%nin%` <- function(x, table) match(x, table, nomatch = 0) == 0
#' Not in (not-in operator for R.)
#'
#' @export "%nin%"
#' @rdname nin
#'
#' @param x vector or \code{NULL}: the values to be matched.
#' @param y vector or \code{NULL}: the values to be matched against.
#' @return The negation of \code{\link[base:match]{\%in\%}}.
#' @examples
#' 1 %nin% 2:10
#' c("a", "b") %nin% c("a", "c", "d")
"%nin%" <- function(x, y) {
  return( !(x %in% y) )
}
