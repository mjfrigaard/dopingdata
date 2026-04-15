# Copy the path to top data file in `extdata/` folder on the clipboard

Copy the path to top data file in `extdata/` folder on the clipboard

## Usage

``` r
clip_top_file(ext, pth, ctime)
```

## Arguments

- ext:

  file extension. Default is `'csv'`, accepts: `'rds'`, `'txt'`,
  `'tsv'`, or `'dat'`

- pth:

  path to `extdata` subfolder

- ctime:

  modification time of the most recent file, as a POSIXct datetime

## Value

Called for its side effects: prints file name and modification time to
the console, and copies a ready-to-use import statement to the
clipboard. Returns the clipboard content string invisibly.
