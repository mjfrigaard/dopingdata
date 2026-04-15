# Scraping USADA sanctions

Packages:

``` r
library(polite)
library(dopingdata)
library(robotstxt)
options(robotstxt_warn = FALSE)
```

## USADA sanction data

The data I’ll be downloading comes from [USADA sanctions
table](https://www.usada.org/testing/results/sanctions/).

## Use your manners

Because this package is built on top of the efforts of the fine people
who collected, organized, and shared their data, we’re going to use the
[`polite` package](https://dmi3kno.github.io/polite/) for harvesting the
HTML tables.

To install this package, run the code below:

``` r
devtools::install_github("dmi3kno/polite")
library(polite)
```

`polite` has many options for ethically scraping data (check out the
[package website](https://dmi3kno.github.io/polite/reference/index.html)
for more information), but I’ve chosen to follow the handy [polite
template](https://dmi3kno.github.io/polite/#polite-template):

``` r
polite::use_manners()
```

### Check `robots.txt`

I’ll check the `robots.txt` file before scraping the website:

``` r
# retrieval
rtxt <- robotstxt::robotstxt(domain = "https://www.usada.org/")

# printing
rtxt$check(
  # check permissions 
  paths = c("testing/", 
            "testing/results/", 
            "testing/results/sanctions/"),
  # bots
  bot   = "*"
)
```

All three paths are `TRUE`, but I will also check the domain with
[`robotstxt::get_robotstxt()`](https://docs.ropensci.org/robotstxt/reference/get_robotstxt.html):

``` r
rt <- robotstxt::get_robotstxt(
  domain = "https://www.usada.org/testing/results/sanctions/")
# printing
cat(rt[1])
```

I can see the `Allow: /` configuration [gives us access to
download](https://kinsta.com/blog/wordpress-robots-txt/#how-to-use-robotstxt-allow-all-to-give-robots-full-access-to-your-site)
the data.

### Scraping with `polite` and `rvest`

Below are the steps used to scrape the sanctions table:

``` r
usada_url = "https://www.usada.org/testing/results/sanctions/"
usada_nodes <- polite::bow(usada_url) |> 
  polite::scrape() |> 
  rvest::html_nodes("table") 
usada_sanctions_raw <- rvest::html_table(usada_nodes[[1]])
```

### Exporting raw data

Some common tasks (like exporting the raw data as a .csv file into a
date-stamped folder and file) have been wrapped in functions:

``` r
export_data(
  x = usada_sanctions_raw, 
  path = "../dev")
```

There’s also an
[`export_extdata()`](https://mjfrigaard.github.io/dopingdata/reference/export_extdata.md)
function if you’re storing the data in a package:

``` r
export_extdata(
  x = usada_sanctions_raw, 
  path = "dev")
```

What does the raw data look like?

``` r
usada_sanctions_raw <- read.delim(system.file("extdata", "demo", "2023-12-21-usada_raw.csv", 
                                   package = "dopingdata"), sep = ",")
str(usada_sanctions_raw)
#> 'data.frame':    937 obs. of  5 variables:
#>  $ Athlete           : chr  "Rodriguez, Daniel" "Park, Mariah" "Frey, John" "Jha, Kanak" ...
#>  $ Sport             : chr  "Mixed Martial Arts" "Weightlifting" "Cycling" "Table Tennis" ...
#>  $ Substance.Reason  : chr  "Ostarine; LGD-4033" "Chlorthalidone" "Non-Analytical: Refusal to Submit to Sample Collection" "Non-Analytical: 3 Whereabouts Failures" ...
#>  $ Sanction.Terms    : chr  "3-Month Suspenion" "Public Warning" "2-Year Suspension; Loss of Results" "1-Year Suspension; Loss of Results" ...
#>  $ Sanction.Announced: chr  "12/14/2023" "12/11/2023" "12/05/2023" "Original: 3/20/2023; Updated: 12/01/2023" ...
```

You can also use the
[`scrape_sanctions()`](https://mjfrigaard.github.io/dopingdata/reference/scrape_sanctions.md)
function.
