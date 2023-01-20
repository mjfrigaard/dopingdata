#' Parse string into individual terms (as tibble)
#'
#' @param search_term
#'
#' @return tibble of unique terms and term
#' @export str_parse_term
#'
#' @examples
#' require(stringr)
#' require(purrr)
#' require(tibble)
#' str_parse_term(term = "A large size in stockings is hard to sell.")
str_parse_term <- function(term) {
    # split to remove commas
    split_terms <- stringr::str_split(term, ",")
    # convert to vector
    term_items_chr <- purrr::as_vector(split_terms)
    # remove whitespace (both)
    term_items <- stringr::str_trim(term_items_chr, side = "both")
    # unique term
    # get individual terms
    split_indiv_items <- str_split(term, " ")
    # convert to character
    indiv_items_chr <- purrr::as_vector(split_indiv_items)
    # remove commas
    unique_terms_no_comma <- str_remove_all(indiv_items_chr, ",")
    # get unique
    unique_terms <- base::unique(unique_terms_no_comma)
    # unique_terms

    # TIBBLE
    # get sequence/length of terms
    sq <- seq(max(length(unique_terms), length(term_items)))
    # create tibble from sequence
    terms_tibble <- tibble::tibble(
        `Unique Items` = unique_terms[sq],
        `Term` = term_items[sq]
    )
    return(terms_tibble)
}
