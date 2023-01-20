#' Process raw data
#'
#' @param raw_data
#'
#' @return tibble with standardized names, lowercase text, all character!
#' @export process_text
#'
#' @examples
#' require(palmerpenguins)
#' process_text(palmerpenguins::penguins_raw)
process_text <- function(raw_data) {
  # clean names
  clean_names <- janitor::clean_names(dat = raw_data)
  # lowercase
  lowercase <- purrr::map_df(.x = clean_names, .f = stringr::str_to_lower)
  # remove carriage return
  processed <- dplyr::mutate(
    .data = lowercase,
    dplyr::across(
      where(is.character), ~ stringr::str_replace_all(
        .x,
        pattern = "\\r|\\r\\n|\\n", replacement = " "
      )
    )
  )
  return(processed)
}

# datapasta::df_paste(palmerpenguins::penguins_raw[ 1:3, 2:5])
data.frame(`Sample Number` = c(1, 2, 3),
            Species = c("Adelie Penguin (Pygoscelis adeliae)",
                       "Adelie Penguin (Pygoscelis adeliae)",
                       "Adelie Penguin (Pygoscelis adeliae)"),
            Region = c("Anvers", "Anvers", "Anvers"),
            Island = c("Torgersen", "Torgersen", "Torgersen"))
