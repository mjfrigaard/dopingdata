#' Process raw data
#'
#' @param raw_data raw dataset
#' @param fct include factors?
#'
#' @return data with standardized names, lowercase text, etc.
#'
#' @export
#'
#' @examples
#' usada_raw <- data.frame(
#'   Athlete = c("Doe, Jane", "Roe, Richard"),
#'   Sport = c("Cycling", "Weightlifting"),
#'   Substance.Reason = c("Cannabinoids", "Ostarine"),
#'   Sanction.Terms = c("2-Year Suspension", "1-Year Suspension"),
#'   Sanction.Announced = c("01/01/2024", "02/15/2024")
#' )
#' str(usada_raw)
#' # compare to
#' str(process_text(usada_raw))
process_text <- function(raw_data, fct = FALSE) {
  # convert to data.frame
  raw_data <- as.data.frame(raw_data)
  # clean names (make syntactically valid names in base R)
  nms <- make.names(names(raw_data), unique = TRUE)
  # remove separators
  us_nms <- gsub(pattern = "[^[:alnum:]]+", replacement = "_", x = nms)
  # lowercase
  lc_nms <- make.names(tolower(us_nms), unique = TRUE)
  # remove trailing _
  clean_nmns <- gsub(pattern = "_$", replacement = "", x = lc_nms)
  names(raw_data) <- clean_nmns

  # lowercase (convert all character columns to lowercase)
  lowercase <- raw_data
  char_cols <- sapply(lowercase, is.character)
  lowercase[char_cols] <- lapply(lowercase[char_cols], tolower)

  if (fct) {
    # lowercase (convert all factor columns to lowercase)
    fct_cols <- sapply(lowercase, is.factor)
    lowercase[fct_cols] <- lapply(lowercase[fct_cols], tolower)
  }


  # remove carriage return (replace all carriage returns with space in character columns)
  processed <- lowercase
  processed[char_cols] <- lapply(processed[char_cols], function(column) {
    gsub(pattern = "\\r|\\r\\n|\\n", replacement = " ", x = column)
  })

  return(processed)
}
