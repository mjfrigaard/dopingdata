#' Insert date/time stamp
#'
#' @param include_time logical, include time?
#' @param side include an underscore (_) on the 'left' or 'right' side
#'     (default is 'none')
#'
#' @return polished date (or date and time) stamp
#' @export dtstamp
#'
#'
#' @examples
#' dtstamp()
#' dtstamp(TRUE)
#' dtstamp(FALSE, "r")
#' dtstamp(TRUE, "l")
dtstamp <- function(include_time = FALSE, side = "none") {
    # date
    raw_dt <- base::Sys.time()
    chr_raw_dt <- base::as.character(raw_dt)
    date_time <- base::as.character(
                    stringr::str_split(chr_raw_dt, " ", n = 2,
                                        simplify = TRUE))
    # clean date
    dt <- date_time[1]
    t <- date_time[2]
    hms_vector <- base::as.character(
                    stringr::str_split(t, ":", n = 3,
                                        simplify = TRUE))
    h <- hms_vector[1]
    m <- hms_vector[2]
    s <- round(as.numeric(hms_vector[3]), 0)
    # browser()
    # clean time
    hms_nmd_vec <- base::paste0(h, m, s)
    # time or date
    if (include_time) {
        stamp <- base::paste0(dt, "-", toupper(hms_nmd_vec))
    } else {
        stamp <- dt
    }
    # hyphen
    if (side == "l") {
      polished <- base::paste0("_", stamp)
    } else if (side == "r") {
      polished <- base::paste0(stamp, "_")
    } else {
      polished <- stamp
    }
    return(polished)
}
