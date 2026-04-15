# Create a regular expression with word boundaries

Create a regular expression with word boundaries

## Usage

``` r
create_word_boundary(string)
```

## Arguments

- string:

  character vector of items

## Value

wb_regex regular expression

## Examples

``` r
require(stringr)
#> Loading required package: stringr
wb_regex <- create_word_boundary(c("pink", "salmon."))
str_view(stringr::sentences, wb_regex, match = TRUE)
#>  [12] │ A rod is used to catch <pink> <salmon>.
#> [714] │ A <pink> shell was found on the sandy beach.
```
