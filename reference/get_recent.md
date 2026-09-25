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
#> ✔ The last modified date in '/tmp/RtmpXYZHd1': 2026-09-25
#>        dstmp 
#> "2026-09-25" 
get_recent(tempdir(), full = TRUE)
#> ✔ The last modified datetime in '/tmp/RtmpXYZHd1': 2026-09-25 19:03:33.5386536121368
#>                              dtstmp 
#> "2026-09-25 19:03:33.5386536121368" 
```
