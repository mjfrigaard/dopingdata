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
#> [1] "2026-04-15"
dtstamp(TRUE)
#> [1] "2026-04-15-214544"
dtstamp(FALSE, "r")
#> [1] "2026-04-15_"
dtstamp(TRUE, "l")
#> [1] "_2026-04-15-214544"
```
