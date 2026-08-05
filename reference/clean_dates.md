# Clean sanction dates

Clean sanction dates

## Usage

``` r
clean_dates(df, date_col, split = "updated", pattern = "original")
```

## Arguments

- df:

  processed USADA dataset with messy dates

- date_col:

  sanction date column (usually `sanction_announced`)

- split:

  regex to pass to split argument of
  [`strsplit()`](https://rdrr.io/r/base/strsplit.html) (defaults to
  `"updated"`)

- pattern:

  regex for other non-date pattern (defaults to `"original"`)

## Value

tibble with cleaned dates

## Examples

``` r
sanction_dates <- data.frame(
  athlete = c("doe, jane", "roe, richard"),
  ugly_dates = c(
    "original: 01/01/2020 updated: 02/15/2021",
    "original: 03/03/2019 updated: 04/04/2020"
  )
)
sanction_dates
#>        athlete                               ugly_dates
#> 1    doe, jane original: 01/01/2020 updated: 02/15/2021
#> 2 roe, richard original: 03/03/2019 updated: 04/04/2020

clean_dates(
df = sanction_dates,
date_col = "ugly_dates",
split = "updated",
pattern = "original")
#>        athlete                               ugly_dates pattern_date split_date
#> 1    doe, jane original: 01/01/2020 updated: 02/15/2021   2020-01-01 2021-02-15
#> 2 roe, richard original: 03/03/2019 updated: 04/04/2020   2019-03-03 2020-04-04
```
