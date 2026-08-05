# Refresh the cached USADA sanctions data

Scrapes the current [USADA sanctions
page](https://www.usada.org/results/sanctions/) and overwrites the local
cache used by
[`get_sanctions_data()`](https://mjfrigaard.github.io/dopingdata/reference/get_sanctions_data.md)
and
[`get_prohibited_association()`](https://mjfrigaard.github.io/dopingdata/reference/get_prohibited_association.md).
This is the only function in the package that makes a network request.

## Usage

``` r
update_sanctions_data(verbose = FALSE)
```

## Arguments

- verbose:

  print progress messages. Default `FALSE`

## Value

called for its side effect of writing the local cache. Returns
`invisible(NULL)`

## Examples

``` r
# \donttest{
update_sanctions_data(verbose = TRUE)
#> Scraping: https://www.usada.org/results/sanctions/
#> Sanctions data cache refreshed.
# }
```
