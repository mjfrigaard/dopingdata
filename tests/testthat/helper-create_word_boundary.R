  tv_create_regex_wb <- function(string) {
    lc <- tolower(string)
    punc <- stringr::str_remove_all(lc, "[[:punct:]]+")
    wb_regex <- paste0("\\b", punc, "\\b", collapse = "|")
    return(wb_regex)
  }
