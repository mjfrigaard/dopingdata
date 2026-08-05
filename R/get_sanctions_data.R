#' Fetch the USADA sanctions page and extract both data tables
#'
#' @param verbose print progress messages. Default `FALSE`
#'
#' @return a list with two elements: `sanctions` and `prohibited_association`,
#'   each a `data.frame`
#'
#' @keywords internal
util_fetch_usada_sanctions_page <- function(verbose = FALSE) {
  usada_url <- "https://www.usada.org/results/sanctions/"

  if (verbose) message("Scraping: ", usada_url)

  usada_page <- polite::bow(usada_url) |>
    polite::scrape()

  table_nodes <- rvest::html_elements(usada_page, "table")
  if (length(table_nodes) < 2) {
    cli::cli_abort(c(
      "Expected 2 tables (sanctions, prohibited association) at {.url {usada_url}}.",
      "x" = "Found {length(table_nodes)}."
    ))
  }

  sanctions <- rvest::html_table(table_nodes[[1]])
  util_validate_cols(
    sanctions,
    c("Athlete", "Sport", "Substance/Reason", "Sanction Terms", "Sanction Announced"),
    "sanctions"
  )

  prohibited_association <- rvest::html_table(table_nodes[[2]])
  util_validate_cols(
    prohibited_association,
    c("NAME", "SUSPENSION ENDS\n(mm/dd/yyyy)"),
    "prohibited association"
  )

  list(sanctions = sanctions, prohibited_association = prohibited_association)
}

#' Validate that a scraped table has the expected column names
#'
#' @param x data.frame to check
#' @param expected_cols character vector of expected column names
#' @param label human-readable label for the table, used in the error message
#'
#' @keywords internal
util_validate_cols <- function(x, expected_cols, label) {
  if (!identical(names(x), expected_cols)) {
    cli::cli_abort(c(
      "The USADA {label} table columns have changed.",
      "x" = "Expected: {.val {expected_cols}}",
      "i" = "Found: {.val {names(x)}}"
    ))
  }
}

#' Local cache directory for USADA sanctions data
#'
#' @return path to the cache directory (created if missing)
#'
#' @keywords internal
util_sanctions_cache_dir <- function() {
  cache_dir <- tools::R_user_dir("dopingdata", which = "cache")
  if (!dir.exists(cache_dir)) {
    dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)
  }
  cache_dir
}

#' Write an object to the sanctions cache
#'
#' @param x object to cache
#' @param file cache file name, e.g. `"sanctions.rds"`
#'
#' @keywords internal
util_write_cache <- function(x, file) {
  saveRDS(x, file.path(util_sanctions_cache_dir(), file))
}

#' Read an object from the sanctions cache
#'
#' @param file cache file name, e.g. `"sanctions.rds"`
#'
#' @keywords internal
util_read_cache <- function(file) {
  readRDS(file.path(util_sanctions_cache_dir(), file))
}

#' Check whether a cached file is missing or older than `max_age_days`
#'
#' @param file cache file name
#' @param max_age_days maximum cache age, in days
#'
#' @keywords internal
util_cache_is_stale <- function(file, max_age_days) {
  cache_path <- file.path(util_sanctions_cache_dir(), file)
  if (!file.exists(cache_path)) {
    return(TRUE)
  }
  cache_age_days <- as.numeric(difftime(Sys.time(), file.info(cache_path)$mtime, units = "days"))
  cache_age_days > max_age_days
}

#' Refresh the cached USADA sanctions data
#'
#' Scrapes the current [USADA sanctions page](https://www.usada.org/results/sanctions/)
#' and overwrites the local cache used by [get_sanctions_data()] and
#' [get_prohibited_association()]. This is the only function in the package
#' that makes a network request.
#'
#' @param verbose print progress messages. Default `FALSE`
#'
#' @return called for its side effect of writing the local cache. Returns
#'   `invisible(NULL)`
#'
#' @export
#'
#' @examples
#' \donttest{
#' update_sanctions_data(verbose = TRUE)
#' }
update_sanctions_data <- function(verbose = FALSE) {
  usada_data <- util_fetch_usada_sanctions_page(verbose = verbose)
  util_write_cache(usada_data$sanctions, "sanctions.rds")
  util_write_cache(usada_data$prohibited_association, "prohibited_association.rds")
  if (verbose) message("Sanctions data cache refreshed.")
  invisible(NULL)
}

#' Get USADA sanctions data
#'
#' Returns the USADA sanctions table (Athlete, Sport, Substance/Reason,
#' Sanction Terms, Sanction Announced), using a local cache that's
#' automatically refreshed when stale.
#'
#' @param refresh force a refresh of the cache before returning data.
#'   Default `FALSE`
#' @param max_age_days maximum cache age, in days, before an automatic
#'   refresh is triggered. Default `7`
#' @param verbose print progress messages. Default `FALSE`
#'
#' @return a `data.frame` of USADA sanctions
#'
#' @export
#'
#' @examples
#' \donttest{
#' get_sanctions_data()
#' }
get_sanctions_data <- function(refresh = FALSE, max_age_days = 7, verbose = FALSE) {
  if (refresh || util_cache_is_stale("sanctions.rds", max_age_days)) {
    update_sanctions_data(verbose = verbose)
  }
  util_read_cache("sanctions.rds")
}

#' Get USADA prohibited-association data
#'
#' Returns the list of athlete support personnel (coaches, trainers, etc.)
#' currently ineligible under the Prohibited Association rule (Name,
#' Suspension Ends), using a local cache that's automatically refreshed when
#' stale.
#'
#' @param refresh force a refresh of the cache before returning data.
#'   Default `FALSE`
#' @param max_age_days maximum cache age, in days, before an automatic
#'   refresh is triggered. Default `7`
#' @param verbose print progress messages. Default `FALSE`
#'
#' @return a `data.frame` of currently-ineligible support personnel
#'
#' @export
#'
#' @examples
#' \donttest{
#' get_prohibited_association()
#' }
get_prohibited_association <- function(refresh = FALSE, max_age_days = 7, verbose = FALSE) {
  if (refresh || util_cache_is_stale("prohibited_association.rds", max_age_days)) {
    update_sanctions_data(verbose = verbose)
  }
  util_read_cache("prohibited_association.rds")
}
