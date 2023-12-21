test_that("add_match_col() works", {

  terms <- data.frame(term = c("A cramp is no small danger on a swim.",
                               "The soft cushion broke the man's fall.",
                               "There is a lag between thought and act.",
                               "Eight miles of woodland burned to waste."))

  expected <- data.frame(term = c("A cramp is no small danger on a swim.",
                                  "The soft cushion broke the man's fall.",
                                  "There is a lag between thought and act.",
                                  "Eight miles of woodland burned to waste."),
                          match_upper = c("A", "T", "T", "E"),
                          match_vowels = c("a, i, o, a, a, e, o, a, i",
                                          "e, o, u, i, o, o, e, e, a, a",
                                          "e, e, i, a, a, e, e, e, o, u, a, a",
                                          "i, i, e, o, o, o, a, u, e, o, a, e"))

  terms$match_upper <- add_match_col(terms$term, "[[:upper:]]")
  terms$match_vowels <- add_match_col(terms$term, "[aeiou]")

  expect_equal(object = terms, expected = expected)
})
