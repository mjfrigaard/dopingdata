#' Return the most recent modification date
#'
#' @param pth path to file or folder
#' @param full return datetime (instead of date)
#'
#'
#' @return most recently modified file
#'
#' @export get_recent
#'
#' @examples
#' get_recent("wrong")
#' get_recent("inst/extdata/")
#' get_recent("inst/extdata/raw", full = TRUE)
get_recent <- function(pth = ".", full = FALSE) {
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
     vrsn <- purrr::set_names(now_stmp,
                    nm = 'dtstmp')
     cli::cli_alert_success("The last modified datetime in '{pth}': {vrsn}")
   } else {
     vrsn <- purrr::set_names(tdy_stmp,
                    nm = 'dstmp')
     cli::cli_alert_success("The last modified date in '{pth}': {vrsn}")
   }
  return(vrsn)
}
