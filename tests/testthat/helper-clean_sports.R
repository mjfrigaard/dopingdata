tv_clean_sports <- function(df, sport_col, tidy = TRUE) {
  usada_sports <- dplyr::mutate(df,
  # support_personnel
  support_personnel =
    dplyr::if_else(condition = stringr::str_detect(
      {{ sport_col }}, "support personnel"),
      true = TRUE, false = FALSE, missing = NA),
  # track & field
  sport = stringr::str_replace_all(sport, 'track and field', 'track & field'),
  # brazilian jiu-jitsu
  sport = dplyr::case_when(
    sport == 'brazillian jiu-jitsu' ~ 'brazilian jiu-jitsu',
    TRUE ~ sport),
  # paralympic
    paralympic =
      dplyr::if_else(condition = stringr::str_detect(sport, "paralympic|para"),
        true = TRUE, false = FALSE, missing = NA),
  # multiple_sports
    multiple_sports =
      dplyr::if_else(condition = stringr::str_detect(sport, "and |, "),
        true = TRUE, false = FALSE, missing = NA)
    )

  if (tidy) {

    multp_usada_sports <- dplyr::filter(usada_sports,
      multiple_sports == TRUE) |>
    tidyr::separate_rows(sport, sep = "and|, ") |>
    dplyr::mutate(sport = stringr::str_trim(sport, side = "both"))

    # get athlete names
    multp_sports_athletes <- unique(multp_usada_sports['athlete'])
    # remove from
    single_usada_sports <- dplyr::filter(usada_sports,
                                            athlete %nin% multp_sports_athletes)

    tidy_sports <- dplyr::bind_rows(single_usada_sports, multp_usada_sports)

    return(tidy_sports)

  } else {

    return(usada_sports)

  }

}
