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
#> # A tibble: 1,059 × 5
#>    Athlete        Sport `Substance/Reason` `Sanction Terms` `Sanction Announced`
#>    <chr>          <chr> <chr>              <chr>            <chr>               
#>  1 Lingafeldt, S… Weig… Testosterone       1-Year Suspensi… 09/24/2026          
#>  2 Samelo do Ama… Braz… Drostanolone; Nan… 3-Year Suspensi… 09/21/2026          
#>  3 Oprea, Erin    Tria… Ostarine; LGD-403… 5-Year Suspensi… 09/11/2026          
#>  4 Boyle, Evan    Cycl… Non-Analytical: 3… 16-Month Suspen… Original: 04/24/202…
#>  5 Meador, Laura  Weig… Testosterone       4-Year Suspensi… 09/03/2026          
#>  6 Porfírio de A… Braz… Cannabinoids       3-Month Suspens… 09/02/2026          
#>  7 Oberst, Emily  Whee… Spironolactone     Public Warning   09/01/2026          
#>  8 Hobbs, Aleia   Trac… Non-Analytical: U… 6-Month Suspens… 08/21/2026          
#>  9 MacDermott, J… Weig… Spironolactone; A… 2-Year Suspensi… 08/20/2026          
#> 10 Aguila-Ramos,… Para… Non-Analytical: R… 4-Year Suspensi… 08/18/2026          
#> # ℹ 1,049 more rows
# }
```
