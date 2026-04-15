# Create a Regular Expression Pattern

`make_regex()` takes a character vector and returns a regular expression
pattern. If `wb` is `TRUE`, word boundaries (`\\b`) are added before and
after each element.

## Usage

``` r
make_regex(x, wb = FALSE)
```

## Arguments

- x:

  A character vector to be converted into a regular expression.

- wb:

  Logical; if `TRUE`, adds word boundaries around each element of `x`.

## Value

A character string containing the regular expression pattern.

## Examples

``` r
make_regex(c("apple", "banana"))
#> [1] "apple|banana"
make_regex(c("cat", "dog"), wb = TRUE)
#> [1] "\\bcat\\b|\\bdog\\b"
```
