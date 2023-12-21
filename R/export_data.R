#' Export data object to path
#'
#' `export_data()` will export a given `data.frame` or `tibble` to a specified
#' path with a data stamp prefix.
#'
#' @param x dataset to export
#' @param path string, path to folder
#' @param type string, type of exported file
#'
#'
#' @return exported data message
#'
#' @export export_data
#'
export_data <- function(x, path = "", type = "csv") {

  tday <- as.character(Sys.Date())

  raw_pth <- file.path(path, tday)
  dir.create(raw_pth, recursive = TRUE, showWarnings = FALSE)

  xnm <- deparse(substitute(x))

  if (type == "csv") {
    raw_data_file_pth <- file.path(raw_pth, paste0(tday, "-", xnm, ".csv"))
  } else if (type == "rds") {
    raw_data_file_pth <- file.path(raw_pth, paste0(tday, "-", xnm, ".rds"))
  } else if (type == "tsv") {
    raw_data_file_pth <- file.path(raw_pth, paste0(tday, "-", xnm, ".tsv"))
  } else {
    raw_data_file_pth <- file.path(raw_pth, paste0(tday, "-", xnm, ".csv"))
  }


  message("Exporting data: ", raw_data_file_pth)
  if (type == "csv") {
    write.csv(x, raw_data_file_pth, row.names = FALSE)
  } else if (type == "rds") {
    saveRDS(object = x, file = raw_data_file_pth)
  } else if (type == "tsv") {
    write_delim(x = x, file = raw_data_file_pth, delim = "\t")
  } else {
    write.csv(x, raw_data_file_pth, row.names = FALSE)
  }

  if (!file.exists(raw_data_file_pth)) {
    stop("Failed to export :(")
  } else {
    message("Data successfully exported!")
  }
}
