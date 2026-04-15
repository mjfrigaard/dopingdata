
test_that("make_regex() returns pattern without word boundaries by default", {
  expect_equal(make_regex(c("apple", "banana")), "apple|banana")
})

test_that("make_regex() adds word boundaries when wb = TRUE", {
  expect_equal(make_regex(c("cat", "dog"), wb = TRUE), "\\bcat\\b|\\bdog\\b")
})

test_that("make_regex() errors on non-character input", {
  expect_error(make_regex(123))
})
