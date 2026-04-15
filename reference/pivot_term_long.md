# Parse string into individual terms

Parse string into individual terms

## Usage

``` r
pivot_term_long(term, sep = "[^[:alnum:]]+")
```

## Arguments

- term:

  A character vector of one or more strings to parse.

- sep:

  A regular expression used to split each string into terms. Defaults to
  `"[^[:alnum:]]+"` (any run of non-alphanumeric characters).

## Value

A data.frame with two columns: `unique_items` (individual terms split
from the input) and `term` (the original input string, repeated in the
first row of each group with `NA` for subsequent rows).

## Examples

``` r
pivot_term_long(term = "A large size in stockings is hard to sell.")
#>   unique_items                                       term
#> 1            A A large size in stockings is hard to sell.
#> 2        large                                       <NA>
#> 3         size                                       <NA>
#> 4           in                                       <NA>
#> 5    stockings                                       <NA>
#> 6           is                                       <NA>
#> 7         hard                                       <NA>
#> 8           to                                       <NA>
#> 9         sell                                       <NA>
```
