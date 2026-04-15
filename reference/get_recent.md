# Return the most recent modification date

Return the most recent modification date

## Usage

``` r
get_recent(pth = ".", full = FALSE)
```

## Arguments

- pth:

  path to file or folder

- full:

  return datetime (instead of date)

## Value

A named character vector: `"dstmp"` containing the most recent
modification date, or `"dtstmp"` containing the full datetime when
`full = TRUE`.

## Examples

``` r
if (FALSE) { # \dontrun{
# invalid path raises an error
get_recent("wrong")
} # }
get_recent(tempdir())
#> ✔ The last modified date in '/tmp/Rtmp9u7z6J': 2026-04-15
#>        dstmp 
#> "2026-04-15" 
get_recent(tempdir(), full = TRUE)
#> ✔ The last modified datetime in '/tmp/Rtmp9u7z6J': 2026-04-15 21:45:38.1902344226837
#>                              dtstmp 
#> "2026-04-15 21:45:38.1902344226837" 
```
