# Insert date/time stamp

Insert date/time stamp

## Usage

``` r
dtstamp(include_time = FALSE, side = "none")
```

## Arguments

- include_time:

  logical, include time?

- side:

  include an underscore (\_) on the 'left' or 'right' side (default is
  'none')

## Value

polished date (or date and time) stamp

## Examples

``` r
dtstamp()
#> [1] "2026-09-25"
dtstamp(TRUE)
#> [1] "2026-09-25-190412"
dtstamp(FALSE, "r")
#> [1] "2026-09-25_"
dtstamp(TRUE, "l")
#> [1] "_2026-09-25-190412"
```
