# Classify banned WADA substances

usada_data should be the table of sanctions from the [United States
Anti-Doping Agency](https://www.usada.org/news/sanctions). The
`substance_reason` column contains the justification for each sanction.
In some cases, there are multiple substances/reasons, and these should
be identified first.

## Usage

``` r
classify_wada_substances(usada_data, subs_column)
```

## Arguments

- usada_data:

  scraped data from USADA website

- subs_column:

  column with substances/reasons for sanctions

## Value

substances dataset with newly classified substances

## Examples

``` r
sanction_type <- data.frame(
  athlete = c("doe, jane", "roe, richard"),
  substance_reason = c(
    "cannabinoids",
    "androgenic anabolic steroid; cannabinoids"
  )
)
sanction_type
#>        athlete                          substance_reason
#> 1    doe, jane                              cannabinoids
#> 2 roe, richard androgenic anabolic steroid; cannabinoids
substances <- classify_wada_substances(
  usada_data = sanction_type,
  subs_column = "substance_reason"
)
head(substances[c('substance_group', 'substance_reason')])
#>      substance_group                          substance_reason
#> 1    S8 CANNABINOIDS                              cannabinoids
#> 2 S1 ANABOLIC AGENTS androgenic anabolic steroid; cannabinoids
```
