# function that actually fetches response from the web

function that actually fetches response from the web

## Usage

``` r
polite_read_html(
  url,
  ...,
  delay = 5,
  user_agent = paste0("polite ", getOption("HTTPUserAgent"), "bot"),
  force = FALSE,
  verbose = FALSE
)
```

## Arguments

- url:

  web address for scraping

- ...:

  arguments passed to
  [`httr::GET()`](https://httr.r-lib.org/reference/GET.html)

- delay:

  scraping delay. Default 5 sec

- user_agent:

  user agent string. Default value
  `paste0("polite ", getOption("HTTPUserAgent"), "bot")`

- force:

  force re-download of robots.txt

- verbose:

  default FALSE
