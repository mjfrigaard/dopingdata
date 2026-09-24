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
#> # A tibble: 15 × 2
#>    NAME                         `SUSPENSION ENDS\n(mm/dd/yyyy)`
#>    <chr>                        <chr>                          
#>  1 "Edwards, Monzavous \"Rae\"" 11/14/2026                     
#>  2 "Vowell, Michael"            Lifetime                       
#>  3 "Lira, Eric"                 05/08/2029                     
#>  4 "Prempeh, Ernest"            Indefinite*                    
#>  5 "Pearson, Keir"              Lifetime                       
#>  6 "Bell, Kenta"                Lifetime                       
#>  7 "Gingras, Michael"           01/15/2029                     
#>  8 "Bruyneel, Johan"            Lifetime                       
#>  9 "Marti, Jose"                06/11/2027                     
#> 10 "Celaya Lazama, Pedro"       Lifetime                       
#> 11 "Ferrari, Dr. Michele"       Lifetime                       
#> 12 "Leinders, Dr. Geert"        Lifetime                       
#> 13 "Korchemny, Remi"            Lifetime                       
#> 14 "Stewart, Raymond"           Lifetime                       
#> 15 "Graham, Trevor"             Lifetime                       
# }
```
