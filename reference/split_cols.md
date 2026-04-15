# Separate column into multiple columns

Separate column into multiple columns

## Usage

``` r
split_cols(data, col, pattern = "[^[:alnum:]]+", col_prefix)
```

## Arguments

- data:

  `data.frame` or `tibble`

- col:

  column to separate

- pattern:

  regular expression pattern passed to
  [`strsplit()`](https://rdrr.io/r/base/strsplit.html)

- col_prefix:

  prefix for new columns

## Value

data.frame with split columns

## Examples

``` r
d <- data.frame(value = c(29L, 91L, 39L, 28L, 12L),
                name = c("John", "John, Jacob",
                         "John, Jacob, Jingleheimer",
                         "Jingleheimer, Schmidt",
                         "JJJ, Schmidt"))
split_cols(data = d, col = "name", col_prefix = "names")
#>   value                      name      names_1 names_2      names_3
#> 1    29                      John         John    <NA>         <NA>
#> 2    91               John, Jacob         John   Jacob         <NA>
#> 3    39 John, Jacob, Jingleheimer         John   Jacob Jingleheimer
#> 4    28     Jingleheimer, Schmidt Jingleheimer Schmidt         <NA>
#> 5    12              JJJ, Schmidt          JJJ Schmidt         <NA>
```
