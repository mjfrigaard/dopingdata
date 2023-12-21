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
  file.path(inst_path)
}
