# Get USADA prohibited-association data

Returns the list of athlete support personnel (coaches, trainers, etc.)
currently ineligible under the Prohibited Association rule (Name,
Suspension Ends), using a local cache that's automatically refreshed
when stale.

## Usage

``` r
get_prohibited_association(refresh = FALSE, max_age_days = 7, verbose = FALSE)
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

a `data.frame` of currently-ineligible support personnel

## Examples

``` r
# \donttest{
get_prohibited_association()
#> # A tibble: 14 × 2
#>    NAME                 `SUSPENSION ENDS\n(mm/dd/yyyy)`
#>    <chr>                <chr>                          
#>  1 Vowell, Michael      Lifetime                       
#>  2 Lira, Eric           05/08/2029                     
#>  3 Prempeh, Ernest      Indefinite*                    
#>  4 Pearson, Keir        Lifetime                       
#>  5 Bell, Kenta          Lifetime                       
#>  6 Gingras, Michael     01/15/2029                     
#>  7 Bruyneel, Johan      Lifetime                       
#>  8 Marti, Jose          06/11/2027                     
#>  9 Celaya Lazama, Pedro Lifetime                       
#> 10 Ferrari, Dr. Michele Lifetime                       
#> 11 Leinders, Dr. Geert  Lifetime                       
#> 12 Korchemny, Remi      Lifetime                       
#> 13 Stewart, Raymond     Lifetime                       
#> 14 Graham, Trevor       Lifetime                       
# }
```
