str_parse_text <- function(search_term) {
    # split to remove commas
    split_terms <- stringr::str_split(search_term, ",")
    # convert to vector
    term_items_chr <- purrr::as_vector(split_terms)
    # remove whitespace (both)
    term_items <- stringr::str_trim(term_items_chr, side = "both")
    # unique term
    # get individual terms
    split_indiv_items <- str_split(search_term, " ")
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
    terms_tibble <- tibble(
        `Unique Terms` = unique_terms[sq],
        `Terms` = term_items[sq]
    )
    return(terms_tibble)
}
