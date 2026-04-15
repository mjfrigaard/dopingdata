# Create column with matched value (base R)

Create column with matched value (base R)

## Usage

``` r
add_match_col(string, pattern)
```

## Arguments

- string:

  string to search

- pattern:

  regex pattern to match

## Value

matched string

## Examples

``` r
terms <- data.frame(term = c("A cramp is no small danger on a swim.",
                            "The soft cushion broke the man's fall.",
                             "There is a lag between thought and act.",
                             "Eight miles of woodland burned to waste."))
terms$match_upper <- add_match_col(terms$term, "[[:upper:]]")
terms$match_vowels <- add_match_col(terms$term, "[aeiou]")
terms
#>                                       term match_upper
#> 1    A cramp is no small danger on a swim.           A
#> 2   The soft cushion broke the man's fall.           T
#> 3  There is a lag between thought and act.           T
#> 4 Eight miles of woodland burned to waste.           E
#>                         match_vowels
#> 1          a, i, o, a, a, e, o, a, i
#> 2       e, o, u, i, o, o, e, e, a, a
#> 3 e, e, i, a, a, e, e, e, o, u, a, a
#> 4 i, i, e, o, o, o, a, u, e, o, a, e
```
