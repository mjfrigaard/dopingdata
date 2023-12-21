#' Export data to `inst/extdata/` or `inst/extdata/raw`
#'
#' @param x data to export
#' @param path path to 'inst/' folder (and only 'inst/' folder!)
#' @param type logical, is this a raw dataset?
#'
#'
#' @return exported data
#'
#' @export
#'
export_extdata <- function(x, path = "", type = "csv") {

  tday <- as.character(Sys.Date())

  extdata_pth <- file.path("inst", "extdata", path, tday)

  verify_inst_path(extdata_pth)

  dir.create(extdata_pth, recursive = TRUE, showWarnings = FALSE)

  xnm <- deparse(substitute(x))

  if (type == "csv") {
    extdata_data_file_pth <- file.path(extdata_pth, paste0(tday, "-", xnm, ".csv"))
  } else if (type == "rds") {
    extdata_data_file_pth <- file.path(extdata_pth, paste0(tday, "-", xnm, ".rds"))
  } else if (type == "tsv") {
    extdata_data_file_pth <- file.path(extdata_pth, paste0(tday, "-", xnm, ".tsv"))
  } else {
    extdata_data_file_pth <- file.path(extdata_pth, paste0(tday, "-", xnm, ".csv"))
  }


  message("Exporting data: ", extdata_data_file_pth)
  if (type == "csv") {
    write.csv(x, extdata_data_file_pth, row.names = FALSE)
  } else if (type == "rds") {
    saveRDS(object = x, file = extdata_data_file_pth)
  } else if (type == "tsv") {
    write_delim(x = x, file = extdata_data_file_pth, delim = "\t")
  } else {
    write.csv(x, extdata_data_file_pth, row.names = FALSE)
  }

  if (!file.exists(extdata_data_file_pth)) {
    stop("Failed to export :(")
  } else {
    message("Data successfully exported!")
  }

}

