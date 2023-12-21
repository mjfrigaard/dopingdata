test_that("process_text() works", {

  test_raw <- readRDS(file = test_path("fixtures", "usada_test_raw.rds"))
  # names
  nms <- make.names(names(test_raw), unique = TRUE)
  # clean names
  us_nms <- gsub(pattern = "[^[:alnum:]]+", replacement = "_", x = nms)
  # lowercase names
  lc_nms <- make.names(tolower(us_nms), unique = TRUE)
  # clean trailing '_'
  clean_nmns <- gsub(pattern = "_$", replacement = "", x = lc_nms)

  # rename test_raw
  raw_data <- test_raw
  # assign names
  names(raw_data) <- clean_nmns

  # rename lowercase
  lowercase <- raw_data
  # get character columns
  char_cols <- sapply(lowercase, is.character)
  # convert to lowercase
  lowercase[char_cols] <- lapply(lowercase[char_cols], tolower)
  # rename to processed
  processed <- lowercase
  # remove returns
  processed[char_cols] <- lapply(processed[char_cols], function(column) {
    gsub(pattern = "\\r|\\r\\n|\\n", replacement = " ", x = column)
  })

  expect_equal(process_text(test_raw), processed)

  expect_equal(class(process_text(test_raw)), "data.frame")

  expect_equal(names(process_text(test_raw)),
    c("athlete", "sport", "substance_reason",
      "sanction_terms", "sanction_announced",
      "sourced"))

  expect_equal(object = mapply(process_text(test_raw),
                               FUN = class,
                               SIMPLIFY = TRUE,
                               USE.NAMES = TRUE),
    expected = col_classes <- c(athlete = "character",
                                sport = "character",
                                substance_reason = "character",
                                sanction_terms = "character",
                                sanction_announced = "character",
                                sourced = "Date")
  )


})
