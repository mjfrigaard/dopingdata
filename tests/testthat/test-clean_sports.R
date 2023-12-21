test_that("clean_sports() works", {

  test_sports <- readRDS(file = test_path("fixtures", "usada_test_sports.rds"))

  tv_sports <- tv_clean_sports(
      df = test_sports,
      sport_col = sport)

  base_sports <- clean_sports(
      df = test_sports,
      sport_col = "sport")

  expect_equal(object = dim(tv_sports), expected = dim(base_sports))
  expect_equal(object = names(tv_sports), expected = names(base_sports))

  expect_equal(class(base_sports), "data.frame")

  col_classes <- c(athlete = "character",
                    sport = "character",
                    substance_reason = "character",
                    sanction_terms = "character",
                    sanction_announced = "character",
                    sanction_date = "Date",
                    support_personnel = "logical",
                    paralympic = "logical",
                    multiple_sports = "logical")

  expect_equal(object = mapply(base_sports,
                               FUN = class,
                               SIMPLIFY = TRUE,
                               USE.NAMES = TRUE), expected = col_classes)

  expect_equal(object = mapply(tv_sports,
                               FUN = class,
                               SIMPLIFY = TRUE,
                               USE.NAMES = TRUE), expected = col_classes)

})
