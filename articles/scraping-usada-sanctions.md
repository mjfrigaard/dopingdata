# Scraping USADA sanctions

Packages:

``` r

library(dopingdata)
library(robotstxt)
options(robotstxt_warn = FALSE)
```

## USADA sanction data

The data comes from the [USADA sanctions
page](https://www.usada.org/results/sanctions/), which hosts two tables:

- the **sanctions table** (Athlete, Sport, Substance/Reason, Sanction
  Terms, Sanction Announced)
- the **prohibited association table**, listing athlete support
  personnel (coaches, trainers, etc.) currently ineligible under the
  Prohibited Association rule (Name, Suspension Ends)

## Use your manners

Because this package is built on top of the efforts of the fine people
who collected, organized, and shared their data, `dopingdata` uses the
[`polite` package](https://dmi3kno.github.io/polite/) to fetch this
page, which respects `robots.txt` and its crawl-delay rules.

### Check `robots.txt`

``` r

rtxt <- robotstxt::robotstxt(domain = "https://www.usada.org/")

rtxt$check(
  paths = c("results/", "results/sanctions/"),
  bot   = "*"
)
```

## Getting the data

Rather than scraping the page yourself, `dopingdata` provides a small
cached API modeled on the
[`fightr`](https://benyamindsmith.github.io/fightr/index.html) package:
`get_*()` functions return data from a local cache and refresh it
automatically once it’s more than `max_age_days` old (7 days by
default), and `update_*()` functions force a refresh. Fetching only ever
happens when you explicitly call one of these functions — never on
package load.

``` r

sanctions <- get_sanctions_data()
str(sanctions)
```

``` r

prohibited_association <- get_prohibited_association()
str(prohibited_association)
```

To force a refresh regardless of cache age:

``` r

update_sanctions_data(verbose = TRUE)
```

[`update_sanctions_data()`](https://mjfrigaard.github.io/dopingdata/reference/update_sanctions_data.md)
makes a single request for the page and refreshes both cached tables, so
calling
[`get_sanctions_data()`](https://mjfrigaard.github.io/dopingdata/reference/get_sanctions_data.md)
and
[`get_prohibited_association()`](https://mjfrigaard.github.io/dopingdata/reference/get_prohibited_association.md)
back to back doesn’t trigger two separate scrapes.

## Exporting the data

Some common tasks (like exporting a data frame as a `.csv` file into a
date-stamped folder) have been wrapped in functions:

``` r

usada_sanctions_raw <- get_sanctions_data()
str(usada_sanctions_raw)
#> Classes 'tbl_df', 'tbl' and 'data.frame':    1059 obs. of  5 variables:
#>  $ Athlete           : chr  "Lingafeldt, Seth" "Samelo do Amaral, Rider" "Oprea, Erin" "Boyle, Evan" ...
#>  $ Sport             : chr  "Weightlifting" "Brazilian Jiu-Jitsu" "Triathlon" "Cycling" ...
#>  $ Substance/Reason  : chr  "Testosterone" "Drostanolone; Nandrolone; 19-norsteroids" "Ostarine; LGD-4033; Testosterone" "Non-Analytical: 3 Whereabouts Failures; Non-Analytical: Violation of Period of Ineligibility" ...
#>  $ Sanction Terms    : chr  "1-Year Suspension; Loss of Results" "3-Year Suspension; Loss of Results" "5-Year Suspension; Loss of Results" "16-Month Suspension; Loss of Results; Additional 2-Month Suspension" ...
#>  $ Sanction Announced: chr  "09/24/2026" "09/21/2026" "09/11/2026" "Original: 04/24/2026; Updated: 09/09/2026" ...
```

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
