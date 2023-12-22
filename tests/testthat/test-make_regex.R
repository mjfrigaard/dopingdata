

test_that("make_regex() test with word boundaries", {
  expect_equal(make_regex(c("apple", "banana")), "apple|banana")
})

#
test_that("make_regex() test without word boundaries", {
  expect_equal(make_regex(c("cat", "dog"), wb = FALSE), "\\bcat\\b|\\bdog\\b")
})


test_that("make_regex() test for handling non-character input", {
  expect_error(make_regex(123))
})
