#' Scrape the UASA website sanctions data
#'
#' @return tibble of raw sanctions data
#'
#' @export
#'
#' @examples
#' # scrape_sanctions()
scrape_sanctions <- function(dest_path) {
  usada_url = "https://www.usada.org/testing/results/sanctions/"
  usada_nodes <- polite::bow(usada_url) |>
  polite::scrape() |>
  rvest::html_nodes("table")
  usada_raw <- rvest::html_table(usada_nodes[[1]])
  export_data(x = usada_raw, path = dest_path)
}
