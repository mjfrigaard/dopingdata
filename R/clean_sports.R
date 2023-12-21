#' Clean/tidy USADA sports
#'
#' @param df data.frame/tibble of processed USADA dataset with messy sports
#' @param sport_col character sport column (usually `sport`)
#' @param tidy logical. Tidy the sports after cleaning/wrangling?
#'
#' @return tibble with cleaned sports
#'
#' @export
clean_sports <- function(df, sport_col, tidy = TRUE) {
  # 'track & field'
  df$sport <- gsub('track and field', 'track & field', df[[sport_col]])
  # 'brazilian jiu-jitsu'
  df$sport <- ifelse(df$sport == 'brazillian jiu-jitsu', 'brazilian jiu-jitsu', df[[sport_col]])
  # 'support personnel'
  df$support_personnel <- grepl("support personnel", df[[sport_col]])
  # 'paralympic'
  df$paralympic <- grepl("paralympic|para", df[[sport_col]])
  # 'multiple_sports'
  df$multiple_sports <- grepl("and |, ", df[[sport_col]])

  if (tidy) {
    # multiple sports
    multp_sport_athletes <- df[df[['multiple_sports']] == TRUE, ]
    # single sports
    single_sport_athletes <- df[df[['multiple_sports']] == FALSE, ]

    # split multiple sports
    separated_sports <- strsplit(multp_sport_athletes[[sport_col]], "and|, ")
    tidy_multp_sport_athletes <- multp_sport_athletes[rep(seq_len(nrow(multp_sport_athletes)), sapply(separated_sports, length)), ]
    tidy_multp_sport_athletes$sport <- unlist(separated_sports)
    tidy_multp_sport_athletes$sport <- trimws(tidy_multp_sport_athletes[[sport_col]])

    # Combine single and multiple sports data
    tidy_sports <- rbind(single_sport_athletes, tidy_multp_sport_athletes)

    return(tidy_sports)
  } else {
    return(df)
  }
}
