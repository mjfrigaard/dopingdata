#' Verify inst/ path
#'
#' @param inst_path
#'
#' @return invisible
#'
#' @export verify_inst_path
#'
verify_inst_path <- function(inst_path = NULL) {
  # Construct regular expression pattern
  inst_rgx <- paste0("(", "^", inst_path, "$", ")|(", "^\\./", inst_path, ")|(", "^\\.\\./", inst_path, "$", ")")

  # Check if inst_path matches the pattern
  if (!grepl(inst_rgx, inst_path)) {
    stop(paste0("!`", inst_path, "` is not a valid 'inst/' folder path!"))
  }

  # Construct and return the path
  file.path("inst", inst_path)
}



#' Export data to `inst/extdata/` or `inst/extdata/raw`
#'
#' @param x data to export
#' @param inst_path path to 'inst/' folder (and only 'inst/' folder!)
#' @param raw logical, is this a raw dataset?
#'
#'
#' @return exported data
#'
#' @export export_extdata
#'
#' @examples
#' # df <- tibble::tibble(x = 1:3,
#' #                     y = c("a", "b", "c"),
#' #                     z = c(TRUE, FALSE, NA))
#' # export_extdata(x = df, inst_path = "inst/", raw = TRUE)
#' # export_extdata(x = df, inst_path = "inst/", raw = FALSE)
#' # unlink(paste0("inst/extdata/raw/", as.character(Sys.Date()), "_df.csv"))
#' # unlink(paste0("inst/extdata/", "df.csv"))
export_extdata <- function(x, path = "", raw = TRUE) {
  tday <- as.character(Sys.Date())

  if (raw) {
    raw_pth <- if (path != "extdata/raw") {
      file.path("inst", "extdata", "raw", tday, path)
    } else {
      file.path("inst", "extdata", "raw", tday)
    }

    verify_inst_path(raw_pth)
    dir.create(raw_pth, recursive = TRUE, showWarnings = FALSE)

    xnm <- deparse(substitute(x))
    raw_data_dir <- file.path(raw_pth, paste0(tday, "-", xnm, ".csv"))

    message("Exporting raw data: ", xnm, ".csv")
    write.csv(x, raw_data_dir, row.names = FALSE)

    if (!file.exists(raw_data_dir)) {
      stop("Failed to export :(")
    } else {
      message("Raw data successfully exported!")
    }
  } else {
    extdata_pth <- if (path != "extdata") {
      file.path("inst", "extdata", tday, path)
    } else {
      file.path("inst", "extdata", tday)
    }

    verify_inst_path(extdata_pth)
    dir.create(extdata_pth, recursive = TRUE, showWarnings = FALSE)

    xnm <- deparse(substitute(x))
    extdata_dir <- file.path(extdata_pth, paste0(tday, "-", xnm, ".csv"))

    message("Exporting data: ", xnm, ".csv")
    write.csv(x, extdata_dir, row.names = FALSE)

    if (!file.exists(extdata_dir)) {
      stop("Failed to export :(")
    } else {
      message("Data successfully exported!")
    }
  }
}

#' Export raw data to path
#'
#' @param x data to export
#' @param inst_path path to folder
#'
#'
#' @return exported data
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
    message("Raw data successfully exported!")
  }
}
