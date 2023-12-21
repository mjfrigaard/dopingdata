tv_classify_substance <- function(df, substance, value, substance_col = "substance_reason", wb = FALSE) {
    if (wb == TRUE) {
      subs_regex <- create_regex_wb(substance)
    } else {
      subs_regex <- paste0(substance, collapse = "|")
    }

    substance <- dplyr::mutate(
      .data = df,
      substance_group = dplyr::case_when(
        stringr::str_detect(.data[[substance_col]], subs_regex) ~  value,
        TRUE ~ substance_group
      )
    )

    return(substance)
  }
