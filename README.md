
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dopingdata

<!-- badges: start -->

![](https://img.shields.io/badge/lifecycle-experimental-orange.svg)

<!-- https://img.shields.io/badge/lifecycle-stable-green.svg -->
<!-- badges: end -->

`dopingdata` contains data from the [United States Anti-Doping
Agency](https://en.wikipedia.org/wiki/United_States_Anti-Doping_Agency)
for exploration, modeling, and visualizations. The datasets in this
package are derived from from the [USADA
website](https://www.usada.org/) and the [World Anti-Doping Agency
(WADA) banned substances
list](https://www.wada-ama.org/en/prohibited-list?q=).

## Installation

You can install the development version of `dopingdata` like so:

``` r
# install.packages("devtools")
devtools::install_github("mjfrigaard/dopingdata")
```

## Raw Data

Each dataset was ha**rvest**ed using the
[`rvest`](https://rvest.tidyverse.org/) and
[`xml2`](https://xml2.r-lib.org/) packages, but using manners (with the
[`polite`](https://dmi3kno.github.io/polite/) package).

- All raw datasets have a date (`YYYY-MM-DD`) prefix and `_raw` suffix
  - See the `scraping-usada-sanctions.Rmd` and
    `scraping-usada-proh-assoc.Rmd` vignettes for more information

  - The raw data is then saved in the `inst/extdata/raw` folder

<!-- -->

    #> inst/extdata/raw
    #> ├── 2023-01-21_usada_prohib_assoc_raw.csv
    #> ├── 2023-01-21_usada_sanctions_raw.csv
    #> ├── 2023-01-22_usada_prohib_assoc_raw.csv
    #> └── 2023-01-22_usada_sanctions_raw.csv

## Processed Data

Processed datasets have the same dimensions and structure as the `_raw`
data, but they’ve been formatted for easier wrangling/manipulation

- All processed datasets have a `_pro` suffix

  - Processed data have all had the column names formatted with
    `janitor::clean_names()`

  - All of the text has been converted to lowercase

  - See the `scraping-usada-sanctions.Rmd` and
    `scraping-usada-proh-assoc.Rmd` vignettes for more information

  - Processed datasets are in the `inst/extdata/` folder:

<!-- -->

    #> inst/extdata/
    #> ├── usada_prohib_assoc_pro.csv
    #> └── usada_sanctions_pro.csv

## Derived Data

Additional datasets derived from the from the processed data and live in
the `inst/extdata/` folder (and do not have a date prefix or any
suffixes).

### Sanction Dates

The `sanction_announced` initially includes two dates (original,
updated) for a selection of athletes. These observations are wrangled
and formatted into dates. Derived from the `usada_sanctions_pro.csv`
data.

- See the `vignettes/sanction-dates.Rmd` vignette for more information:

      #> inst/extdata/
      #> └── usada_dates.csv

### Sports

The **`sport`** column has been ‘tidied’ and athletes/support personnel
listed with more than one sport have been repeated in the data. These
data are derived from the `usada_dates.csv` data.

- the sports separated and ‘tidied’ in `vignettes/sanction-sports.Rmd`:

      #> inst/extdata/
      #> └── tidy_sports.csv

### Adverse Analytical Findings (AAF)

The **Single Substance Violations** (i.e., Adverse Analytical Finding,
AAF) are derived from `tidy_sports.csv`:

- Adverse analytical finding (AAF) sanctions with a single substance are
  in `vignettes/single-aaf-substances.Rmd`:

      #> inst/extdata/
      #> └── tidy_single_aafs.csv

The **Multiple Substance Violations** (i.e., Adverse Analytical Finding,
AAF) are derived from

- Adverse analytical finding (AAF) sanctions with multiple substance are
  in `vignettes/multiple-aaf-substances.Rmd`:

      #> inst/extdata/
      #> └── tidy_multp_aaf_subs.csv

### Non-Analytical Anti-doping Rule Violation (ADRV)

The **Single Substance, Non-Analytic Violations** (i.e., Non-Analytical
Anti-doping Rule Violation, ADRV) are derived from the `tidy_sports.csv`
data.

The **Multiple Substance, Non-Analytic Violations** (i.e.,
Non-Analytical Anti-doping Rule Violation, ADRV) are derived from the
`tidy_sports.csv` data.

### Sanction terms

The type and length of suspension are derived `tidy_single_aafs.csv` and
`tidy_multp_aaf_subs.csv` data.

### Prohibited Associations

The prohibited associations are derived from the
`usada_prohib_assoc_pro.csv` data.

## WADA data

This package also includes a list of the [World Anti-Doping Agency
(WADA)](https://en.wikipedia.org/wiki/World_Anti-Doping_Agency) banned
substances (published online
[here](https://www.wada-ama.org/en/prohibited-list?q=)).

    #> inst/extdata/wada/
    #> ├── wada-2019-english-prohibited-list.xlsx
    #> └── wada_2019_english_prohibited_list.pdf

### More WADA Resources on banned substances

- [USADA -
  UFC](https://ufc.usada.org/wp-content/uploads/UFC-Prohibited-List.pdf)
