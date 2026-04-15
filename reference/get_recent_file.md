# Return the most recent data file in folder

Return the most recent data file in folder

## Usage

``` r
get_recent_file(path = "default", regex = NULL, ext = ".csv")
```

## Arguments

- path:

  path to data folder

- regex:

  regular expression `pattern` passed to
  [`list.files()`](https://rdrr.io/r/base/list.files.html)

- ext:

  file extension. Default is 'csv', accepts: 'rds', 'txt', 'tsv', or
  'dat'

## Value

Called for its side effects: prints the file name and modification time
to the console, and copies a ready-to-use import statement to the
clipboard. Returns the clipboard content string invisibly.
