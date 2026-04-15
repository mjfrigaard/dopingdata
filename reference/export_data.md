# Export data object to path

`export_data()` will export a given `data.frame` or `tibble` to a
specified path with a data stamp prefix.

## Usage

``` r
export_data(x, path = "", type = "csv")
```

## Arguments

- x:

  dataset to export

- path:

  string, path to folder

- type:

  string, type of exported file (`"csv"`, `"rds"`, or `"tsv"`)

## Value

exported data message
