#' Export data to inst/extdata/
#'
#' @param x data to export
#' @param inst_path path to 'inst/' folder (and only 'inst/' folder!)
#' @param raw logical, is this a raw dataset?
#'
#' @importFrom fs dir_exists
#' @importFrom stringr str_detect
#' @importFrom stringr str_replace_all
#' @importFrom fs dir_create
#' @importFrom fs file_exists
#' @importFrom cli cli_process_start
#' @importFrom vroom vroom_write
#' @importFrom cli cli_process_done
#' @importFrom cli cli_alert_success
#'
#' @return exported data
#' @export export_extdata
#'
#' @examples
#' df <- tibble::tibble(x = 1:3,
#'                      y = c("a", "b", "c"),
#'                      z = c(TRUE, FALSE, NA))
#' export_extdata(x = df, inst_path = "inst/", raw = TRUE)
#' export_extdata(x = df, inst_path = "inst/", raw = FALSE)
export_extdata <- function(x, inst_path, raw = TRUE) {
  # verify path exists
  if (!fs::dir_exists(inst_path)) {
    stop("! Can't locate the 'inst/' folder!")
  }
  # check path doesn't include additional sub-folders
  inst_rgx <- "(^inst$)|(^inst/$)|(^./inst/$)|(^./inst$)|(^../inst/$)|(^../inst$)"
  if (!stringr::str_detect(inst_path, inst_rgx)) {
    stop("! Not a valid 'inst/' folder path!")
  }
  # export raw data....
  if (raw == TRUE) {
    raw_inst_dir <- paste0(
      inst_path, "/extdata/raw/")
    # remove extra '/'
    cln_raw_inst_dir <- stringr::str_replace_all(raw_inst_dir, "//", "/")
    fs::dir_create(cln_raw_inst_dir)
    # create raw path
    raw_data_dir <- paste0(cln_raw_inst_dir, dtstamp(side = "r"),
      deparse(substitute(x)), ".csv")
    # remove extra '/'
    cln_raw_data_dir <- stringr::str_replace_all(raw_data_dir, "//", "/")
    cli::cli_process_start(
      msg = paste0("Exporting raw data: ", deparse(substitute(x)))
    )

    vroom::vroom_write(x = x, file = cln_raw_data_dir, delim = ",")
    if (!fs::file_exists(cln_raw_data_dir)) stop("Failed to export :(")
    if (fs::file_exists(cln_raw_data_dir)) cli::cli_process_done()
    cli::cli_alert_success("Raw data successfully exported!")
    # export data....
  } else {
    inst_dir <- paste0(
      inst_path, "/extdata/")
    # remove extra '/'
    cln_inst_dir <- stringr::str_replace_all(inst_dir, "//", "/")
    fs::dir_create(cln_inst_dir)
    data_dir <- paste0(cln_inst_dir, deparse(substitute(x)), ".csv")
    # remove extra '/'
    cln_data_dir <- stringr::str_replace_all(data_dir, "//", "/")
    cli::cli_process_start(
      msg = paste0("Exporting data: ", deparse(substitute(x))))
    vroom::vroom_write(x = x, file = cln_data_dir, delim = ",")
    if (!fs::file_exists(cln_data_dir)) stop("Failed to export :(")
    if (fs::file_exists(cln_data_dir)) cli::cli_process_done()
    cli::cli_alert_success("Data successfully exported!")
  }
}
