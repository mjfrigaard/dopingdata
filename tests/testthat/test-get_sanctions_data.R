fake_sanctions_page <- function(...) {
  list(
    sanctions = data.frame(
      Athlete = "Doe, Jane",
      Sport = "Cycling",
      `Substance/Reason` = "Ostarine",
      `Sanction Terms` = "2-Year Suspension",
      `Sanction Announced` = "01/01/2024",
      check.names = FALSE
    ),
    prohibited_association = data.frame(
      NAME = "Roe, Richard",
      `SUSPENSION ENDS` = "01/01/2026",
      check.names = FALSE
    )
  )
}

local_sanctions_cache_dir <- function(env = parent.frame()) {
  cache_dir <- withr::local_tempdir(.local_envir = env)
  testthat::local_mocked_bindings(
    util_sanctions_cache_dir = function() cache_dir,
    .env = env
  )
  cache_dir
}

test_that("update_sanctions_data() writes both cache files from one fetch", {
  local_sanctions_cache_dir()
  testthat::local_mocked_bindings(
    util_fetch_usada_sanctions_page = fake_sanctions_page
  )

  update_sanctions_data()

  expect_true(file.exists(file.path(util_sanctions_cache_dir(), "sanctions.rds")))
  expect_true(file.exists(file.path(util_sanctions_cache_dir(), "prohibited_association.rds")))
})

test_that("get_sanctions_data() fetches on a cache miss", {
  local_sanctions_cache_dir()
  fetch_calls <- 0
  testthat::local_mocked_bindings(
    util_fetch_usada_sanctions_page = function(...) {
      fetch_calls <<- fetch_calls + 1
      fake_sanctions_page()
    }
  )

  out <- get_sanctions_data()

  expect_equal(fetch_calls, 1)
  expect_equal(out$Athlete, "Doe, Jane")
})

test_that("get_sanctions_data() does not refetch a fresh cache", {
  local_sanctions_cache_dir()
  fetch_calls <- 0
  testthat::local_mocked_bindings(
    util_fetch_usada_sanctions_page = function(...) {
      fetch_calls <<- fetch_calls + 1
      fake_sanctions_page()
    }
  )

  get_sanctions_data()
  get_sanctions_data()

  expect_equal(fetch_calls, 1)
})

test_that("get_sanctions_data(refresh = TRUE) always refetches", {
  local_sanctions_cache_dir()
  fetch_calls <- 0
  testthat::local_mocked_bindings(
    util_fetch_usada_sanctions_page = function(...) {
      fetch_calls <<- fetch_calls + 1
      fake_sanctions_page()
    }
  )

  get_sanctions_data()
  get_sanctions_data(refresh = TRUE)

  expect_equal(fetch_calls, 2)
})

test_that("get_sanctions_data() refetches once the cache is stale", {
  local_sanctions_cache_dir()
  fetch_calls <- 0
  testthat::local_mocked_bindings(
    util_fetch_usada_sanctions_page = function(...) {
      fetch_calls <<- fetch_calls + 1
      fake_sanctions_page()
    }
  )

  get_sanctions_data()
  Sys.setFileTime(file.path(util_sanctions_cache_dir(), "sanctions.rds"), Sys.time() - as.difftime(8, units = "days"))
  get_sanctions_data(max_age_days = 7)

  expect_equal(fetch_calls, 2)
})

test_that("get_prohibited_association() reads its own cache file", {
  local_sanctions_cache_dir()
  testthat::local_mocked_bindings(
    util_fetch_usada_sanctions_page = fake_sanctions_page
  )

  out <- get_prohibited_association()

  expect_equal(out$NAME, "Roe, Richard")
})

test_that("util_fetch_usada_sanctions_page() errors when the sanctions table schema changes", {
  local_mocked_bindings(
    bow = function(...) NULL,
    scrape = function(...) NULL,
    .package = "polite"
  )
  local_mocked_bindings(
    html_elements = function(x, css) {
      list(
        data.frame(Wrong = "column"),
        data.frame(NAME = "x", `SUSPENSION ENDS\n(mm/dd/yyyy)` = "y", check.names = FALSE)
      )
    },
    html_table = function(x) x,
    .package = "rvest"
  )

  expect_error(util_fetch_usada_sanctions_page(), "columns have changed")
})
