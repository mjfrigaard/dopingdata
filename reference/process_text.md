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
str(example_usada_raw)
#> 'data.frame':    250 obs. of  5 variables:
#>  $ Athlete           : chr  "*Name Removed" "Richardson, Sha'Carri" "*Name Removed" "*Name Removed" ...
#>  $ Sport             : chr  "Cycling" "Track and Field" "Track and Field" "Bobsled and Skeleton" ...
#>  $ Substance.Reason  : chr  "Non-Analytical: Use and Possession (EPO)" "Cannabinoids" "Non-Analytical: Refusal to Submit to Sample Collection" "Elevated T/E" ...
#>  $ Sanction.Terms    : chr  "2-Year Suspension - Loss of Results" "1-Month Suspension; Loss of Results" "2-Year Suspension - Loss of Results" "2-Year Suspension - Loss of Results" ...
#>  $ Sanction.Announced: chr  "" "07/02/2021" "" "" ...
# compare to
str(process_text(example_usada_raw))
#> 'data.frame':    250 obs. of  5 variables:
#>  $ athlete           : chr  "*name removed" "richardson, sha'carri" "*name removed" "*name removed" ...
#>  $ sport             : chr  "cycling" "track and field" "track and field" "bobsled and skeleton" ...
#>  $ substance_reason  : chr  "non-analytical: use and possession (epo)" "cannabinoids" "non-analytical: refusal to submit to sample collection" "elevated t/e" ...
#>  $ sanction_terms    : chr  "2-year suspension - loss of results" "1-month suspension; loss of results" "2-year suspension - loss of results" "2-year suspension - loss of results" ...
#>  $ sanction_announced: chr  "" "07/02/2021" "" "" ...
```
