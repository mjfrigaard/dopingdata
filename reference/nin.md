# Not in (not-in operator for R.)

Not in (not-in operator for R.)

## Usage

``` r
x %nin% y
```

## Arguments

- x:

  vector or `NULL`: the values to be matched.

- y:

  vector or `NULL`: the values to be matched against.

## Value

The negation of [`%in%`](https://rdrr.io/r/base/match.html).

## Examples

``` r
1 %nin% 2:10
#> [1] TRUE
c("a", "b") %nin% c("a", "c", "d")
#> [1] FALSE  TRUE
```
