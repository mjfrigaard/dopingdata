# Process raw data

Process raw data

## Usage

``` r
process_text(raw_data, fct = FALSE)
```

## Arguments

- raw_data:

  raw dataset

- fct:

  include factors?

## Value

data with standardized names, lowercase text, etc.

## Examples

``` r
usada_raw <- data.frame(
  Athlete = c("Doe, Jane", "Roe, Richard"),
  Sport = c("Cycling", "Weightlifting"),
  Substance.Reason = c("Cannabinoids", "Ostarine"),
  Sanction.Terms = c("2-Year Suspension", "1-Year Suspension"),
  Sanction.Announced = c("01/01/2024", "02/15/2024")
)
str(usada_raw)
#> 'data.frame':    2 obs. of  5 variables:
#>  $ Athlete           : chr  "Doe, Jane" "Roe, Richard"
#>  $ Sport             : chr  "Cycling" "Weightlifting"
#>  $ Substance.Reason  : chr  "Cannabinoids" "Ostarine"
#>  $ Sanction.Terms    : chr  "2-Year Suspension" "1-Year Suspension"
#>  $ Sanction.Announced: chr  "01/01/2024" "02/15/2024"
# compare to
str(process_text(usada_raw))
#> 'data.frame':    2 obs. of  5 variables:
#>  $ athlete           : chr  "doe, jane" "roe, richard"
#>  $ sport             : chr  "cycling" "weightlifting"
#>  $ substance_reason  : chr  "cannabinoids" "ostarine"
#>  $ sanction_terms    : chr  "2-year suspension" "1-year suspension"
#>  $ sanction_announced: chr  "01/01/2024" "02/15/2024"
```
