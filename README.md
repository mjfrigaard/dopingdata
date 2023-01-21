
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `dopingdata`

<!-- badges: start -->
<!-- badges: end -->

The goal of `dopingdata` is to provide datasets from the [United States
Anti-Doping
Agency](https://en.wikipedia.org/wiki/United_States_Anti-Doping_Agency)
for exploration, modeling, and visualizations.

The datasets in this package are derived from from the [USADA
website](https://www.usada.org/) and the [World Anti-Doping Agency
(WADA) banned substances
list](https://www.wada-ama.org/en/prohibited-list?q=).

## Installation

You can install the development version of `dopingdata` like so:

``` r
# install.packages("devtools")
devtools::install_github("mjfrigaard/dopingdata")
```

## Harvesting Data

Each dataset was ha**rvest**ed using the
[`rvest`](https://rvest.tidyverse.org/) and
[`xml2`](https://xml2.r-lib.org/) packages, but using manners (with the
[`polite`](https://dmi3kno.github.io/polite/) package). See the
`Scraping USADA sanctions` and `Scraping USADA prohibited associations`
vignettes for more information.

The raw data is then saved in the `inst/extdata/raw` folder. Raw
datasets have a date (`YYYY-MM-DD`) prefix and `_raw` suffix.

    #> inst/extdata/raw
    #> ├── 2023-01-20_usada_prohib_assoc_raw.csv
    #> └── 2023-01-20_usada_sanctions_raw.csv

## Processed Data

The processed datasets are created from the scraped raw data and are
structured for different purposes. In all cases, the vignettes contain
the steps and custom functions used to harvest each dataset. All
processed datasets have a `_pro` suffix.

Processed datasets have the same dimensions and structure as the `_raw`
data, but they’ve been formatted for easier wrangling/manipulation.

Processed datasets are in the `inst/extdata/` folder:

    #> inst/extdata/
    #> ├── usada_prohib_assoc_pro.csv
    #> └── usada_sanctions_pro.csv

## Derived Data

The following datasets are derived from the processed data:

1.  Sanction Dates  
2.  Sports  
3.  Substances (AAF)  
4.  Non-Analytic Sanctions (ADRV)  
5.  Sanction Terms  
6.  Prohibited Associations  
7.  Athletes

All derived datasets are in the `inst/extdata/` folder (and do not have
a date prefix or any suffixes).

### Sanction Dates

Derived from `usada_sanctions_pro.csv`:

- the dates are wrangled and formatted in
  `vignettes/sanction-dates.Rmd`:

      #> inst/extdata/
      #> └── usada_dates.csv

### Sports

Derived from `usada_dates.csv`:

- the sports separated and ‘tidied’ in `vignettes/sanction-sports.Rmd`:

      #> inst/extdata/
      #> └── tidy_sports.csv

### Substances (AAF)

Derived from `tidy_sports.csv`:

- Adverse analytical findings with a single substance are in
  `vignettes/sanction-aaf-substances.Rmd`:

      #> inst/extdata/
      #> └── classified_single_aaf_substance.csv

### Non-Analytic Sanctions (ADRV)

### Sanction terms

### Prohibited Associations

### Athletes

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
