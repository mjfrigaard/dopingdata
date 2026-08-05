# Get USADA sanctions data

Returns the USADA sanctions table (Athlete, Sport, Substance/Reason,
Sanction Terms, Sanction Announced), using a local cache that's
automatically refreshed when stale.

## Usage

``` r
get_sanctions_data(refresh = FALSE, max_age_days = 7, verbose = FALSE)
```

## Arguments

- refresh:

  force a refresh of the cache before returning data. Default `FALSE`

- max_age_days:

  maximum cache age, in days, before an automatic refresh is triggered.
  Default `7`

- verbose:

  print progress messages. Default `FALSE`

## Value

a `data.frame` of USADA sanctions

## Examples

``` r
# \donttest{
get_sanctions_data()
#> # A tibble: 1,047 × 5
#>    Athlete        Sport `Substance/Reason` `Sanction Terms` `Sanction Announced`
#>    <chr>          <chr> <chr>              <chr>            <chr>               
#>  1 Miller, Adam   Fiel… Non-Analytical: 3… 2-Year Suspensi… 07/31/2026          
#>  2 Zilcosky, Cha… Weig… Amphetamine        2-Year Suspensi… 07/29/2026          
#>  3 Trabing, Bert  Weig… Anastrozole; Test… 4-Year Suspensi… 07/22/2026          
#>  4 Cantwell, Ste… Para… Dehydrochlormethy… 6-Year Suspensi… 07/16/2026          
#>  5 Edwards, Monz… Trac… Non-Analytical: C… 2-Year Suspensi… 06/29/2026          
#>  6 Quintero, Ang… Weig… Furosemide         2-Year Suspensi… 06/22/2026          
#>  7 Digenis, Hanna Weig… Cannabinoids       3-Month Suspens… 06/17/2026          
#>  8 Bracy-William… Trac… Non-Analytical: 3… 12-Year Suspens… 06/05/2026          
#>  9 Boyle, Evan    Cycl… Non-Analytical: 3… 16-Month Suspen… 04/24/2026          
#> 10 De Sousa, Roo… Braz… Meldonium          3-Year Suspensi… 04/15/2026          
#> # ℹ 1,037 more rows
# }
```
