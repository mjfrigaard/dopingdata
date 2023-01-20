#' Return the most recent modification time for folder and files
#'
#' @param pth path to file or folder
#' @param full return datetime (instead of date)
#'
#' @importFrom fs dir_exists
#' @importFrom fs dir_info
#' @importFrom cli cli_abort
#' @importFrom cli cli_alert_success
#' @importFrom dplyr select
#' @importFrom dplyr mutate
#' @importFrom dplyr arrange
#' @importFrom dplyr slice
#' @importFrom purrr set_names
#' @importFrom dplyr slice
#'
#' @return vrsn character vector of date or datetime
#' @export get_recent_version
#'
#' @examples
#' get_recent_version("wrong")
#' get_recent_version("inst/extdata/")
#' get_recent_version("inst/extdata/raw", full = TRUE)
get_recent_version <- function(pth = ".", full = FALSE) {
  require(fs)
  require(stringr)
  require(purrr)
  if (fs::dir_exists(pth) == FALSE) {
    cli::cli_abort("Sorry--this is not a valid file path")
  } else {
    pth_info <- fs::dir_info(path = pth, all = TRUE, recurse = TRUE)
    pth_mods_raw <- dplyr::select(pth_info, path, modification_time)
    pth_mods <- dplyr::mutate(pth_mods_raw,
                    mod_date = as.Date(modification_time))
    srtd_pth_mods <- dplyr::arrange(pth_mods,
      desc(mod_date))
    vrsns <- as.list(dplyr::slice(srtd_pth_mods, 1))
    tdy_stmp <- as.Date.character(vrsns[['mod_date']])
    now_stmp <- as.character.Date(vrsns[['modification_time']])
  }

   if (full == TRUE) {
     cli::cli_alert_success("Here is the recent datetime:")
     vrsn <- purrr::set_names(now_stmp,
                    nm = 'now_stmp')
   } else {
     cli::cli_alert_success("Here is the recent date:")
     vrsn <- purrr::set_names(tdy_stmp,
                    nm = 'tdy_stmp')
   }
  return(vrsn)
}
