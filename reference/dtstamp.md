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
#> [1] "2026-05-28"
dtstamp(TRUE)
#> [1] "2026-05-28-134233"
dtstamp(FALSE, "r")
#> [1] "2026-05-28_"
dtstamp(TRUE, "l")
#> [1] "_2026-05-28-134233"
```
