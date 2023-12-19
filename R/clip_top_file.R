#' Copy the path to top data file in `extdata/` folder on the clipboard
#'
#' @param ext file extension. Default is `'csv'`, accepts: `'rds'`, `'txt'`, `'tsv'`,
#'     or `'dat'`
#' @param pth path to `extdata` subfolder
#'
#'
#' @return list with extension, path, and modification time for most recent file.
#' @export clip_top_file
#'
clip_top_file <- function(ext, pth, ctime) {
  if (ext %in% c("rds", "txt", "tsv", "dat", "csv")) {
    cli::cli_text(msg = "File last changed: {ctime}")
    cli::cli_text(msg = "File name: {basename(pth)}")
    cpy_clip <- switch(EXPR = ext,
      csv = glue::glue("read.delim(file = '{pth}', sep = ',')"),
      rds = glue::glue("readRDS('{pth}')"),
      txt = glue::glue("read.delim(file = '{pth}', sep = ',')"),
      tsv = glue::glue("read.delim(file = '{pth}', sep = '\t')"),
      dat = glue::glue("read.delim(file = '{pth}', sep = '|')"),
      cli::cli_abort("Invalid file type: {ext}\n
          Try one of: csv, rds, txt, tsv, or dat")
    )
    clipr::write_clip(
      content = cpy_clip,
      return_new = TRUE,
      allow_non_interactive = TRUE
    )
    cli::cli_alert_success("import code pasted to clipboard!")
  } else {
    cli::cli_text("Invalid file type: {ext}")
    cli::cli_alert_info("Try one of: csv, rds, txt, tsv, or dat")
  }
}
