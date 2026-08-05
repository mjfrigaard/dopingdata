# Fetch the USADA sanctions page and extract both data tables

Fetch the USADA sanctions page and extract both data tables

## Usage

``` r
util_fetch_usada_sanctions_page(verbose = FALSE)
```

## Arguments

- verbose:

  print progress messages. Default `FALSE`

## Value

a list with two elements: `sanctions` and `prohibited_association`, each
a `data.frame`
