tv_clean_dates <- function(df) {
  tidyr::separate_rows(data = df,
    sanction_announced, sep = "updated") |>
    dplyr::mutate(sanction_date = stringr::str_remove_all(sanction_announced, ": ")) |>
    dplyr::filter(!stringr::str_detect(sanction_date, "^original")) |>
    dplyr::mutate(sanction_date = anytime::anydate(sanction_date)) |>
    dplyr::mutate(
      sanction_date = dplyr::case_when(
        athlete == "ngetich, eliud" ~ lubridate::as_date("2022-01-25"),
        TRUE ~ sanction_date
      )
    )
}
