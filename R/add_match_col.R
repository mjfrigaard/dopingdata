#' Create column with matched value (base R)
#'
#' @param string string to search
#' @param pattern regex pattern to match
#'
#' @return matched string
#'
#' @export
#'
#' @examples
#' terms <- data.frame(term = c("A cramp is no small danger on a swim.",
#'                             "The soft cushion broke the man's fall.",
#'                              "There is a lag between thought and act.",
#'                              "Eight miles of woodland burned to waste."))
#' terms$match_upper <- add_match_col(terms$term, "[[:upper:]]")
#' terms$match_vowels <- add_match_col(terms$term, "[aeiou]")
#' terms
add_match_col <- function(string, pattern) {

  match_terms <- regmatches(string, gregexpr(pattern, string))

  match_combined <- sapply(match_terms, function(matches) {
    if (length(matches) > 0) {
      trimws(gsub(" ", ", ", paste(matches, collapse = " ")), which = "right")
    } else {
      NA
    }
  })

  match_combined[match_combined == ""] <- NA_character_

  return(match_combined)
}

