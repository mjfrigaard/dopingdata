#' Clean sanction dates
#'
#' @param df processed USADA dataset with messy dates
#' @param date_col sanction date column (usually `sanction_announced`)
#' @param split regex to pass to split argument of `strsplit()` (defaults to `"updated"`)
#' @param pattern regex for other non-date pattern (defaults to `"original"`)
#'
#' @return tibble with cleaned dates
#'
#' @export
clean_dates <- function(df, date_col, split = "updated", pattern = "original") {
  # extract ugly dates
  ugly_dates <- unlist(strsplit(df[[date_col]], split = split))
  # add original date column
  df$pattern_date <- ugly_dates[grepl(pattern = pattern, x = ugly_dates)]
  df$split_date <- ugly_dates[!grepl(pattern = pattern, x = ugly_dates)]
  # clean split date
  df$split_date <- gsub("^[:punct:]", "", df[['split_date']])
  df$split_date <- trimws(df[['split_date']], which = "both")
  df$split_date <- as.Date(x = df[['split_date']], format = "%m/%d/%Y")
  # clean pattern date
  df$pattern_date <- gsub(pattern, "", df[['pattern_date']])
  df$pattern_date <- gsub(pattern = "^[:punct:]", "", df[['pattern_date']])
  df$pattern_date <- gsub(pattern = ":|;|,", "", df[['pattern_date']])
  df$pattern_date <- trimws(df[['pattern_date']], which = "both")
  df$pattern_date <- as.Date(x = df[['pattern_date']], format = "%m/%d/%Y")
  return(df)
}
