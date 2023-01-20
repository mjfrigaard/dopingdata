#' Match string and extract the matched value
#'
#' @param string string to search
#' @param pattern regex pattern to match
#'
#' @return matched string
#' @export str_extract_matches
#'
#' @examples
#' require(dplyr)
#' require(tidyr)
#' dplyr::mutate(dplyr::starwars,
#'       match = str_extract_matches(name, "Skywalker")) |>
#'   dplyr::select(last_col())
str_extract_matches <- function(string, pattern) {
  # extract all matches
  match_terms <- stringr::str_extract_all(
    string = {{ string }},
    pattern = pattern,
    simplify = TRUE
  )
  # df for easier manipulation :)
  match_df <- base::as.data.frame(match_terms)
  if (ncol(match_df) > 0) {
    # unite the matches
    match_unite <- tidyr::unite(match_df,
      col = "match", sep = " "
    )
    # trim up the string
    matches <- dplyr::mutate(match_unite,
      match = str_trim(match, "right"),
      match = str_replace_all(match, " ", ", ")
    )
  } else {
    matches <- tibble::add_column(
      .data = tibble::as_tibble(match_df),
      match = NA_character_
    )
  }
  # convert df to character string
  match_chr <- base::as.character(matches$match)
  # remove empty strings
  matched <- stringr::str_replace_all(
    string = match_chr,
    pattern = "^$",
    replacement = NA_character_
  )
  return(matched)
}


