# Polite download

Polite download

## Usage

``` r
polite_download_file(
  url,
  destfile = guess_basename(url),
  ...,
  quiet = !verbose,
  mode = "wb",
  path = "downloads/",
  user_agent = paste0("polite ", getOption("HTTPUserAgent")),
  delay = 5,
  force = FALSE,
  overwrite = FALSE,
  verbose = FALSE
)
```

## Arguments

- url:

  web address for the file to be downloaded

- destfile:

  name of destination file

- ...:

  additional arguments passed to `download.file`

- quiet:

  default value is inverse of `verbose`

- mode:

  download mode. Default value is "wb"

- path:

  path to save. Default path `downloads/`

- user_agent:

  default value `paste0("polite ", getOption("HTTPUserAgent"))`

- delay:

  default value equal 5

- force:

  force re-download of robots.txt

- overwrite:

  overwrite downloaded file. Default value FALSE

- verbose:

  default value is FALSE
