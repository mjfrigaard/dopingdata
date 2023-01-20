#' Create a folder (with date-stamped sub-folder)
#'
#' @param dir_path parent folder
#' @param dir_name directory name
#'
#' @importFrom fs dir_create
#' @importFrom stringr str_replace_all
#' @importFrom cli cli_alert_success
#' @importFrom clipr write_clip
#'
#' @return path to folder
#' @export create_dir_date
#'
#' @examples
#' create_dir_date(dir_name = "tmp")
#' create_dir_date(dir_path = "tmp", dir_name = "doc")
#' create_dir_date(dir_path = "tmp/x", dir_name = "doc")
#' create_dir_date(dir_path = "tmp/x/", dir_name = "doc")
create_dir_date <- function(dir_path = "", dir_name) {
  # create folders
  if (dir_path == "") {
    dir_date <- base::paste0(dir_name, "/",
      base::noquote(Sys.Date()), "/")
    date_data_dir <- base::paste0(dir_path, dir_date)
    clean_dir <-
      stringr::str_replace_all(date_data_dir, "//", "/")
    fs::dir_create(clean_dir)
    cli::cli_alert_success(paste0("Creating folder: ", clean_dir))
    clipr::write_clip(
      content = paste0("'", clean_dir, "'"),
      return_new = TRUE,
      allow_non_interactive = TRUE
    )
    cli::cli_alert_success("path is on clipboard!")
  } else {
    fs::dir_create(dir_path)
    dir_date <- base::paste0("/", base::noquote(Sys.Date()), "/")
    date_data_dir <-
      base::paste0(dir_path, "/", dir_name, dir_date)
    clean_dir <-
      stringr::str_replace_all(date_data_dir, "//", "/")
    fs::dir_create(clean_dir)
    cli::cli_alert_success(paste0("Creating folder: ", clean_dir))
    clipr::write_clip(
      content = paste0("'", clean_dir, "'"),
      return_new = TRUE,
      allow_non_interactive = TRUE
    )
    cli::cli_alert_success("path is on clipboard!")
  }
}
