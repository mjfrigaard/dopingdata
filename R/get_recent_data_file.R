#' Return current data in folder
#'
#' @param folder directory with data files
#' @param type file extension
#'
#' @importFrom cli cli_alert_warning
#' @importFrom fs dir_exists
#' @importFrom dplyr select
#' @importFrom dplyr arrange
#' @importFrom dplyr desc
#' @importFrom dplyr slice
#' @importFrom cli cli_alert_success
#' @importFrom clipr write_clip
#'
#' @return path to recent data file
#' @export get_recent_data_file
#'
#' @examples # not run
#' get_recent_data_file(folder = "inst/extdata/", type = "txt")
#' get_recent_data_file(folder = "inst/extdata/", type = "csv")
#' get_recent_data_file(folder = "inst/extdata/", type = "tsv")
get_recent_data_file <- function(folder, type) {
  if (!fs::dir_exists(folder)) {
    cli::cli_alert_warning("folder does not exist!")
  } else {
    type_regex <- paste0(".", type, "$")
    info_tbl <-
      fs::dir_info(folder,
        all = TRUE,
        recurse = TRUE,
        regexp = type_regex)
    cols_tbl <- dplyr::select(info_tbl, path, type, birth_time)
    sorted_tbl <-
      dplyr::arrange(.data = cols_tbl, desc(birth_time))
    top_tbl <- dplyr::slice(.data = sorted_tbl, 1)
  }
  if (nrow(top_tbl) < 1) {
    cli::cli_alert_warning("No files of this type in folder!")
    return(top_tbl)
  } else if (type == "csv") {
    recent_path <- as.character(top_tbl$path)
      clipr::write_clip(
        content = paste0("readr::read_csv('", recent_path, "')"),
        return_new = TRUE,
        allow_non_interactive = TRUE)
    cli::cli_alert_success("import code pasted to clipboard!")
    cli::cli_alert_success(
      paste0("use: readr::read_csv('", recent_path, "')"))
  } else if (type == "rds") {
    recent_path <- as.character(top_tbl$path)
      clipr::write_clip(
        content = paste0("readr::read_rds('", recent_path, "')"),
        return_new = TRUE,
        allow_non_interactive = TRUE)
    cli::cli_alert_success("import code pasted to clipboard!")
    cli::cli_alert_success(
      paste0("use: readr::read_rds('", recent_path, "')"))
  } else {
    recent_path <- as.character(top_tbl$path)
      clipr::write_clip(
        content = paste0("'", recent_path, "'"),
        return_new = TRUE,
        allow_non_interactive = TRUE)
      cli::cli_alert_success("path pasted to clipboard!")
  }
}
