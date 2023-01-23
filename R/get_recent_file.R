#' Return the most data file in folder
#'
#' @param path path to data folder
#' @param type file extension. Default is 'csv', accepts: 'rds', 'txt', 'tsv',
#'     or 'dat'
#'
#' @importFrom fs dir_exists
#' @importFrom cli cli_alert_warning
#' @importFrom cli cli_text
#' @importFrom cli cli_alert_info
#' @importFrom glue glue
#' @importFrom fs dir_info
#' @importFrom dplyr select
#' @importFrom dplyr arrange
#' @importFrom dplyr slice
#' @importFrom tools file_ext
#'
#'
#' @return top_pth path the recent file
#' @export get_recent_file
#'
#' @examples
#' require(fs)
#' path_files <- fs::dir_ls("inst/extdata/")
#' path_files
#' get_recent_file("inst/extdata/", "csv")
#' # create tmp dir
#' fs::dir_create("tmp/")
#' get_recent_file("tmp", "csv")
get_recent_file <- function(path, type = "csv") {
  if (!fs::dir_exists(path)) {
    cli::cli_alert_warning("folder does not exist!")
  }
  if (type == "csv") {
    type_regex <- paste0(".", "csv", "$")
  } else if (type %in% c("rds", "txt", "tsv", "dat")) {
    type_regex <- switch(type,
      rds = paste0(".rds$"),
      txt = paste0(".txt$"),
      tsv = paste0(".tsv$"),
      dat = paste0(".dat$"),
      cli::cli_text("Invalid file type: {type}"),
      cli::cli_alert_info("Try one of: rds, txt, tsv, or dat")
    )
  } else {
    stop(glue::glue("No {type} files in directory"))
  }

  info_tbl <- fs::dir_info(
    path = path,
    type = "file",
    recurse = TRUE,
    regexp = type_regex
  )

  if (nrow(info_tbl) < 1) {
    stop(glue::glue("found {nrow(info_tbl)} {type} files in directory"))
  } else {
    cols_tbl <- dplyr::select(info_tbl,
      path, type, mtime = modification_time)
    sorted_tbl <- dplyr::arrange(.data = cols_tbl, desc(mtime))
    top_tbl <- dplyr::slice(.data = sorted_tbl, 1)
    top_pth <- base::as.character(top_tbl[["path"]])
    top_time <- top_tbl[["mtime"]]

  ext <- tools::file_ext(top_pth)
  cpy_clip <- switch(ext,
      csv = paste0("readr::read_csv('", top_pth, "')"),
      rds = paste0("readr::read_rds('", top_pth, "')"),
      txt = paste0("readr::read_delim('", top_pth, "', delim = ',')"),
      tsv = paste0("readr::read_tsv('", top_pth, "')"),
      dat = paste0("readr::read_tsv('", top_pth, "')"))
    cli::cli_text(msg = "File last modified: {top_time}")
      clipr::write_clip(
        content = cpy_clip,
        return_new = TRUE,
        allow_non_interactive = TRUE)
    cli::cli_alert_success("import code pasted to clipboard!")
  }
  return(top_pth)
}
