#' Return the most recent data file in folder
#'
#' @param path path to data folder
#' @param regex regular expression `pattern` passed to `list.files()`
#' @param ext file extension. Default is 'csv', accepts: 'rds', 'txt', 'tsv',
#'     or 'dat'
#'
#'
#' @return path to the most recent file
#'
#' @export
#'
get_recent_file <- function(path = "default", regex = NULL, ext = ".csv") {

  if (path != "default") {
    pth <- file.path(path)
  } else {
    pth <- file.path(getwd())
  }

  if (!dir.exists(pth)) {
    cli::cli_abort("Invalid file path: \n {pth}")
  }

  if (!is.null(regex)) {
  dir_files_tbl <- fs::dir_info(path = pth) |>
    dplyr::select(
      pth = path,
      ctime = change_time) |>
    dplyr::mutate(
      pth = as.character(pth),
      ext = tools::file_ext(pth)) |>
    dplyr::filter(
          stringr::str_detect(pth, regex))
  } else {
  dir_files_tbl <- fs::dir_info(path = pth) |>
    dplyr::select(
      pth = path,
      ctime = change_time) |>
    dplyr::mutate(
      pth = as.character(pth),
      ext = tools::file_ext(pth))
  }

  if (nrow(dir_files_tbl) == 0) {
    cli::cli_abort("Found {nrow(dir_files_tbl)} matching `{regex}` files in: \n '{pth}'")
  }

  file_extn <- as.character(ext)

  files_tbl <- dplyr::filter(dir_files_tbl,
    stringr::str_detect(pth, file_extn))

  if (nrow(files_tbl) == 0) {
    cli::cli_abort("Found {nrow(files_tbl)} files with `{ext}` extension in: \n '{pth}'")
  }

  sorted_files_tbl <- files_tbl |>
    dplyr::arrange(dplyr::desc(ctime))

    top_dttm <- max(sorted_files_tbl$ctime)

    recent_tbl <- dplyr::filter(sorted_files_tbl,
      ctime == lubridate::as_datetime(top_dttm)) |>
      dplyr::select(
        max_dttm = ctime,
        pth,
        ext
      )

    clip_top_file(
      ext = recent_tbl[['ext']],
      pth = recent_tbl[['pth']],
      ctime = recent_tbl[['max_dttm']]
      )
}
