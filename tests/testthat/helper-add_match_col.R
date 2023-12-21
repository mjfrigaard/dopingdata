add_match_column <- function(string, pattern) {
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
      match = stringr::str_trim(match, "right"),
      match = stringr::str_replace_all(match, " ", ", ")
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
