
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
list](https://www.wada-ama.org/en/prohibited-list?q=). Scraping,
processing, and visualizing these data presented so many unique
challenges I decided to combine the utilities into a package.

## Installation

You can install the development version of `dopingdata` like so:

``` r
# install.packages("devtools")
devtools::install_github("mjfrigaard/dopingdata")
```

``` r
library(dopingdata)
```

## Scraping Sanction Data

Each dataset was ha**rvest**ed using the
[`rvest`](https://rvest.tidyverse.org/) and
[`xml2`](https://xml2.r-lib.org/) packages, but using manners (with the
[`polite`](https://dmi3kno.github.io/polite/) package).

``` r
scrape_sanctions(dest_path = "dev")
```

    Exporting raw data: dev/2023-12-19/2023-12-19-usada_sanctions_raw.csv
    Raw data successfully exported!

## Processing Data

`process_text()` performs the following:

- Processed data have all had the column names formatted `snake_case`

- All of the text has been converted to lowercase

``` r
usada_raw <- read.csv("dev/2023-12-19/2023-12-19-usada_sanctions_raw.csv")
str(usada_raw)
#> 'data.frame':    937 obs. of  5 variables:
#>  $ Athlete           : chr  "Rodriguez, Daniel" "Park, Mariah" "Frey, John" "Jha, Kanak" ...
#>  $ Sport             : chr  "Mixed Martial Arts" "Weightlifting" "Cycling" "Table Tennis" ...
#>  $ Substance.Reason  : chr  "Ostarine; LGD-4033" "Chlorthalidone" "Non-Analytical: Refusal to Submit to Sample Collection" "Non-Analytical: 3 Whereabouts Failures" ...
#>  $ Sanction.Terms    : chr  "3-Month Suspenion" "Public Warning" "2-Year Suspension; Loss of Results" "1-Year Suspension; Loss of Results" ...
#>  $ Sanction.Announced: chr  "12/14/2023" "12/11/2023" "12/05/2023" "Original: 3/20/2023; Updated: 12/01/2023" ...
```

``` r
usada <- process_text(raw_data = usada_raw)
str(usada)
#> 'data.frame':    937 obs. of  5 variables:
#>  $ athlete           : chr  "rodriguez, daniel" "park, mariah" "frey, john" "jha, kanak" ...
#>  $ sport             : chr  "mixed martial arts" "weightlifting" "cycling" "table tennis" ...
#>  $ substance_reason  : chr  "ostarine; lgd-4033" "chlorthalidone" "non-analytical: refusal to submit to sample collection" "non-analytical: 3 whereabouts failures" ...
#>  $ sanction_terms    : chr  "3-month suspenion" "public warning" "2-year suspension; loss of results" "1-year suspension; loss of results" ...
#>  $ sanction_announced: chr  "12/14/2023" "12/11/2023" "12/05/2023" "original: 3/20/2023; updated: 12/01/2023" ...
```

## Sanction Dates

`sanction_announced` contains the date the sanction was announced, and
about 30 of these contain two values (`original` and `updated`).
Wrangling these values pose some challenges because they aren’t
*consistently* messy.

``` r
subset(usada, 
  grepl("^original", usada[['sanction_announced']]), 
  sanction_announced)
#> # A tibble: 30 × 1
#>    sanction_announced                       
#>    <chr>                                    
#>  1 original: 3/20/2023; updated: 12/01/2023 
#>  2 original: 05/07/2019; updated: 02/04/2022
#>  3 original: 09/03/21; updated: 01/25/22    
#>  4 original:  11/04/2019;updated: 05/17/2021
#>  5 original 12/20/2018; updated 11/04/2020  
#>  6 original: 10/19/2020updated: 01/05/2021  
#>  7 original: 09/05/2019; updated: 08/26/2020
#>  8 original: 07/22/2020, updated: 11/03/2022
#>  9 original 09/11/2018; updated 01/16/2020  
#> 10 original: 06/17/2019; updated: 12/16/2019
#> # ℹ 20 more rows
```

I decided to split these into three `data.frame`s to wrangle the dates
(`bad_dates`, `good_dates`, and `no_dates`).

``` r
bad_dates <- subset(usada, 
  grepl("^original", usada[['sanction_announced']]))
good_dates <- subset(usada, 
  !grepl("^original", usada[['sanction_announced']]) & sanction_announced != "")
no_dates <- subset(usada,
  athlete == "*name removed" & sanction_announced == "")
```

I’ve written a `clean_dates()` function that takes `date_col`, `split`
and `pattern` arguments:

- `df` = processed USADA dataset with messy dates

- `date_col` = sanction date column (usually `sanction_announced`)

- `split` = regex to pass to split argument of `strsplit()` (defaults to
  `"updated"`)

- `pattern` = regex for other non-date pattern (defaults to
  `"original"`)

``` r
cleaned_dates <- clean_dates(
  df = bad_dates, 
  date_col = "sanction_announced", 
  split = "updated", 
  pattern = "original")
head(
  cleaned_dates[c('sanction_announced', 'pattern_date', 'split_date')]
)
#> # A tibble: 6 × 3
#>   sanction_announced                        pattern_date split_date
#>   <chr>                                     <date>       <date>    
#> 1 original: 3/20/2023; updated: 12/01/2023  2023-03-20   2023-12-01
#> 2 original: 05/07/2019; updated: 02/04/2022 2019-05-07   2022-02-04
#> 3 original: 09/03/21; updated: 01/25/22     0021-09-03   0022-01-25
#> 4 original:  11/04/2019;updated: 05/17/2021 2019-11-04   2021-05-17
#> 5 original 12/20/2018; updated 11/04/2020   2018-12-20   2020-11-04
#> 6 original: 10/19/2020updated: 01/05/2021   2020-10-19   2021-01-05
```

I split the bad dates on `"updated"` and provided `"original"` as the
pattern (the opposite will also work). The `sanction_date` column will
contain the correctly formatted updated `sanction_date`.

``` r
names(cleaned_dates)[names(cleaned_dates) == 'split_date'] <- 'sanction_date'
names(cleaned_dates)[names(cleaned_dates) == 'pattern_date'] <- 'original_date'
head(
  cleaned_dates[c('sanction_announced', 'sanction_date', 'original_date')]
)
#> # A tibble: 6 × 3
#>   sanction_announced                        sanction_date original_date
#>   <chr>                                     <date>        <date>       
#> 1 original: 3/20/2023; updated: 12/01/2023  2023-12-01    2023-03-20   
#> 2 original: 05/07/2019; updated: 02/04/2022 2022-02-04    2019-05-07   
#> 3 original: 09/03/21; updated: 01/25/22     0022-01-25    0021-09-03   
#> 4 original:  11/04/2019;updated: 05/17/2021 2021-05-17    2019-11-04   
#> 5 original 12/20/2018; updated 11/04/2020   2020-11-04    2018-12-20   
#> 6 original: 10/19/2020updated: 01/05/2021   2021-01-05    2020-10-19
```

After formatting `good_dates` and removing `original_date` column we can
combine the two with `rbind()`:

``` r
good_dates$sanction_date <- as.Date(x = good_dates[['sanction_announced']], 
                                    format = "%m/%d/%Y")
# get intersecting names 
nms <- intersect(names(cleaned_dates), names(good_dates))
# bind the two datasets 
usada_dates <- rbind(good_dates, cleaned_dates[nms])
str(usada_dates)
#> 'data.frame':    649 obs. of  6 variables:
#>  $ athlete           : chr  "rodriguez, daniel" "park, mariah" "frey, john" "forrest, evan" ...
#>  $ sport             : chr  "mixed martial arts" "weightlifting" "cycling" "weightlifting" ...
#>  $ substance_reason  : chr  "ostarine; lgd-4033" "chlorthalidone" "non-analytical: refusal to submit to sample collection" "boldenone; drostanolone; methandienone; nandrolone; testosterone" ...
#>  $ sanction_terms    : chr  "3-month suspenion" "public warning" "2-year suspension; loss of results" "3-year suspension; loss of results" ...
#>  $ sanction_announced: chr  "12/14/2023" "12/11/2023" "12/05/2023" "11/30/2023" ...
#>  $ sanction_date     : Date, format: "2023-12-14" "2023-12-11" ...
```

``` r
export_data(x = usada_dates, path = "data-raw")
#> Exporting data: data-raw/2023-12-19/2023-12-19-usada_dates.csv
#> Raw data successfully exported!
```

## Sports

To wrangle the sports, I’ll use packages and functions from the
`tidyverse` (`dplyr`, `stringr`, `tidyr`, etc.), but I also provide the
base R alternatives (wherever possible).

``` r
library(tidyverse)
#> ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
#> ✔ dplyr     1.1.4     ✔ readr     2.1.4
#> ✔ forcats   1.0.0     ✔ stringr   1.5.1
#> ✔ ggplot2   3.4.4     ✔ tibble    3.2.1
#> ✔ lubridate 1.9.3     ✔ tidyr     1.3.0
#> ✔ purrr     1.0.2     
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

`tidyverse` functions will return a `tibble` (not a `data.frame`), which
prints fewer rows to the console.

``` r
usada_sports <- tibble::as_tibble(usada_dates)
str(usada_sports)
#> tibble [649 × 6] (S3: tbl_df/tbl/data.frame)
#>  $ athlete           : chr [1:649] "rodriguez, daniel" "park, mariah" "frey, john" "forrest, evan" ...
#>  $ sport             : chr [1:649] "mixed martial arts" "weightlifting" "cycling" "weightlifting" ...
#>  $ substance_reason  : chr [1:649] "ostarine; lgd-4033" "chlorthalidone" "non-analytical: refusal to submit to sample collection" "boldenone; drostanolone; methandienone; nandrolone; testosterone" ...
#>  $ sanction_terms    : chr [1:649] "3-month suspenion" "public warning" "2-year suspension; loss of results" "3-year suspension; loss of results" ...
#>  $ sanction_announced: chr [1:649] "12/14/2023" "12/11/2023" "12/05/2023" "11/30/2023" ...
#>  $ sanction_date     : Date[1:649], format: "2023-12-14" "2023-12-11" ...
```

We can start by counting the `sport` column:

``` r
usada_sports |> 
  dplyr::count(sport, sort = TRUE)
#> # A tibble: 66 × 2
#>    sport                                   n
#>    <chr>                               <int>
#>  1 mixed martial arts                    135
#>  2 cycling                               125
#>  3 weightlifting                         122
#>  4 track and field                        93
#>  5 wrestling                              15
#>  6 triathlon                              14
#>  7 brazilian jiu-jitsu                    13
#>  8 paralympic track and field             11
#>  9 swimming                                9
#> 10 cycling - athlete support personnel     6
#> # ℹ 56 more rows
```

### Support personnel

Some of the sports aren’t sports–they’re `athlete support personnel`.
These have `support_personnel` identifier.

``` r
usada_sports <- dplyr::mutate(usada_dates, 
  # support_personnel
  support_personnel = 
    dplyr::if_else(condition = stringr::str_detect(
      sport, "support personnel"), 
      true = TRUE, false = FALSE, missing = NA)) 

usada_sports |> 
  dplyr::filter(stringr::str_detect(sport, "support personnel")) |> 
  dplyr::count(sport, support_personnel) |> 
  tidyr::pivot_wider(names_from = support_personnel, values_from = n)
#> # A tibble: 4 × 2
#>   sport                                           `TRUE`
#>   <chr>                                            <int>
#> 1 brazilian jiu-jitsu - athlete support personnel      1
#> 2 cycling - athlete support personnel                  6
#> 3 track and field - athlete support personnel          6
#> 4 weightlifting - athlete support personnel            1
```

### ‘track and field’ or ‘track & field’

I’m going to convert sports like `track & field` as `track and field`
(this will help me determine which athletes/support personnel are
involved in multiple sports).

``` r
usada_sports <- dplyr::mutate(usada_sports,
  # track & field
  sport = stringr::str_replace_all(sport, 'track and field', 'track & field'))

usada_sports |> 
  dplyr::filter(stringr::str_detect(sport, "track")) |> 
  dplyr::count(sport, support_personnel) |> 
  tidyr::pivot_wider(names_from = support_personnel, values_from = n)
#> # A tibble: 6 × 3
#>   sport                                           `FALSE` `TRUE`
#>   <chr>                                             <int>  <int>
#> 1 bobsled and skeleton, track & field                   1     NA
#> 2 para track & field                                    3     NA
#> 3 paralympic track & field                             11     NA
#> 4 paralympic track & field, paralympic volleyball       1     NA
#> 5 track & field                                        95     NA
#> 6 track & field - athlete support personnel            NA      6
```

### Spelling

The incorrect spelling for `brazilian jiu-jitsu`
(`brazillian jiu-jitsu`) is corrected below.

``` r
usada_sports <- dplyr::mutate(usada_sports, 
  # brazilian jiu-jitsu
  sport = dplyr::case_when(
    sport == 'brazillian jiu-jitsu' ~ 'brazilian jiu-jitsu',
    TRUE ~ sport)) 
usada_sports |> 
  dplyr::filter(stringr::str_detect(sport, "jitsu")) |> 
  dplyr::count(sport, sort = TRUE)
#> # A tibble: 2 × 2
#>   sport                                               n
#>   <chr>                                           <int>
#> 1 brazilian jiu-jitsu                                14
#> 2 brazilian jiu-jitsu - athlete support personnel     1
```

### ‘paralympic’

An identifier for paralympic sports: `paralympic`.

``` r
usada_sports <- dplyr::mutate(usada_sports, 
  # paralympic
  paralympic = 
    dplyr::if_else(condition = stringr::str_detect(sport, "paralympic|para"), 
      true = TRUE, false = FALSE, missing = NA)) 

usada_sports |> 
  dplyr::filter(stringr::str_detect(sport, "paralympic|para")) |> 
  dplyr::count(paralympic, sport) |> 
  tidyr::pivot_wider(names_from = paralympic, values_from = n)
#> # A tibble: 14 × 2
#>    sport                                           `TRUE`
#>    <chr>                                            <int>
#>  1 para shooting                                        1
#>  2 para track & field                                   3
#>  3 paralympic archery                                   1
#>  4 paralympic basketball                                2
#>  5 paralympic boccia                                    1
#>  6 paralympic curling                                   1
#>  7 paralympic cycling                                   4
#>  8 paralympic judo                                      4
#>  9 paralympic rugby                                     1
#> 10 paralympic sailing                                   1
#> 11 paralympic snowboarding                              1
#> 12 paralympic table tennis                              1
#> 13 paralympic track & field                            11
#> 14 paralympic track & field, paralympic volleyball      1
```

### Multiple sports

Now we can identify the multiple sports using `and` and `,` in the
regular expression.

``` r
usada_sports <- dplyr::mutate(usada_sports, 
  # multiple_sports
  multiple_sports = 
    if_else(condition = stringr::str_detect(sport, "and |, "), 
      true = TRUE, false = FALSE, missing = NA))

usada_sports |> 
  dplyr::filter(stringr::str_detect(sport, "and |, ")) |> 
  dplyr::count(multiple_sports, sport) |> 
  tidyr::pivot_wider(names_from = multiple_sports, values_from = n)
#> # A tibble: 6 × 2
#>   sport                                           `TRUE`
#>   <chr>                                            <int>
#> 1 bobsled and skeleton                                 4
#> 2 bobsled and skeleton, track & field                  1
#> 3 cycling, triathlon                                   3
#> 4 cycling, weightlifting                               1
#> 5 paralympic track & field, paralympic volleyball      1
#> 6 skiing and snowboarding                              1
```

### Tidy sports

The athletes listed with multiple sports will occupy multiple rows in a
‘tidy’ version of `usada_sports`. We can check this using `count()`
below to verify we have one athlete for each sport:

``` r
usada_sports |> 
  dplyr::filter(multiple_sports == TRUE) |> 
  tidyr::separate_rows(sport, sep = "and|, ") |> 
  dplyr::count(athlete, sport)
#> # A tibble: 23 × 3
#>    athlete                  sport               n
#>    <chr>                    <chr>           <int>
#>  1 allison, kyler           " skeleton"         1
#>  2 allison, kyler           "bobsled "          1
#>  3 bailey, ryan             " skeleton"         1
#>  4 bailey, ryan             "bobsled "          1
#>  5 bailey, ryan             "track & field"     1
#>  6 blandford, jenna         "cycling"           1
#>  7 blandford, jenna         "triathlon"         1
#>  8 cruse, j.c.              " skeleton"         1
#>  9 cruse, j.c.              "bobsled "          1
#> 10 denney phillips, jessica "cycling"           1
#> # ℹ 13 more rows
```

Remove any white-space left over from `tidyr::separate_rows()` with
`stringr::str_trim()` to create a `multp_usada_sports`.

``` r
multp_usada_sports <- usada_sports |> 
  dplyr::filter(multiple_sports == TRUE) |> 
  tidyr::separate_rows(sport, sep = "and|, ") |> 
  dplyr::mutate(sport = stringr::str_trim(sport, side = "both"))
str(multp_usada_sports)
#> tibble [23 × 9] (S3: tbl_df/tbl/data.frame)
#>  $ athlete           : chr [1:23] "allison, kyler" "allison, kyler" "blandford, jenna" "blandford, jenna" ...
#>  $ sport             : chr [1:23] "bobsled" "skeleton" "cycling" "triathlon" ...
#>  $ substance_reason  : chr [1:23] "non-analytical: refusal to submit to sample collection" "non-analytical: refusal to submit to sample collection" "non-analytical: use and possession (testosterone, hgh and oxandrolone)" "non-analytical: use and possession (testosterone, hgh and oxandrolone)" ...
#>  $ sanction_terms    : chr [1:23] "4-year suspension; loss of results; sanction tolled due to retirement" "4-year suspension; loss of results; sanction tolled due to retirement" "4-year suspension - loss of results" "4-year suspension - loss of results" ...
#>  $ sanction_announced: chr [1:23] "10/09/2019" "10/09/2019" "11/28/2017" "11/28/2017" ...
#>  $ sanction_date     : Date[1:23], format: "2019-10-09" "2019-10-09" ...
#>  $ support_personnel : logi [1:23] FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ paralympic        : logi [1:23] FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ multiple_sports   : logi [1:23] TRUE TRUE TRUE TRUE TRUE TRUE ...
```

To combine these with the single-sport athletes, I’ll need to remove the
single occurrences of the multiple-sport athletes in `usada_sports` (and
replace them with the `tidy_usada_sports`)

``` r
# get athlete names
multp_sports_athletes <- unique(multp_usada_sports['athlete'])
# remove from 
single_usada_sports <- dplyr::filter(usada_sports, 
                                        athlete %nin% multp_sports_athletes)
```

Verify there aren’t any duplicates in `single_usada_sports` (there
should be zero rows here)

``` r
single_usada_sports |> 
  dplyr::count(athlete, sanction_date, sport) |> 
  dplyr::filter(n > 1)
#> # A tibble: 0 × 4
#> # ℹ 4 variables: athlete <chr>, sanction_date <date>, sport <chr>, n <int>
```

Now we can combine the two datasets and verify there aren’t any
duplicates (again).

``` r
tidy_sports <- dplyr::bind_rows(single_usada_sports, multp_usada_sports)
tidy_sports |> 
  dplyr::count(athlete, sanction_date, sport) |> 
  dplyr::filter(n > 1)
#> # A tibble: 0 × 4
#> # ℹ 4 variables: athlete <chr>, sanction_date <date>, sport <chr>, n <int>
```

``` r
str(tidy_sports)
#> 'data.frame':    672 obs. of  9 variables:
#>  $ athlete           : chr  "rodriguez, daniel" "park, mariah" "frey, john" "forrest, evan" ...
#>  $ sport             : chr  "mixed martial arts" "weightlifting" "cycling" "weightlifting" ...
#>  $ substance_reason  : chr  "ostarine; lgd-4033" "chlorthalidone" "non-analytical: refusal to submit to sample collection" "boldenone; drostanolone; methandienone; nandrolone; testosterone" ...
#>  $ sanction_terms    : chr  "3-month suspenion" "public warning" "2-year suspension; loss of results" "3-year suspension; loss of results" ...
#>  $ sanction_announced: chr  "12/14/2023" "12/11/2023" "12/05/2023" "11/30/2023" ...
#>  $ sanction_date     : Date, format: "2023-12-14" "2023-12-11" ...
#>  $ support_personnel : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ paralympic        : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ multiple_sports   : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
```

Export `tidy_sports` to `data-raw/`

``` r
export_data(
  x = tidy_sports, 
  path = "data-raw")
#> Exporting data: data-raw/2023-12-19/2023-12-19-tidy_sports.csv
#> Raw data successfully exported!
```

Verify

``` r
fs::dir_tree("data-raw/2023-12-19")
#> data-raw/2023-12-19
#> ├── 2023-12-19-tidy_sports.csv
#> └── 2023-12-19-usada_dates.csv
```

## Adverse Analytic Findings

We’ll start by classifying ‘adverse analytic findings’ for a single
banned substance. I’ve written a `get_recent_file()` function to quickly
import .csv files from a specified directory:

``` r
get_recent_file("data-raw/2023-12-19/", regex = 'sports', ext = '.csv')
#> File last changed: 2023-12-19 14:29:09.367087
#> File name: 2023-12-19-tidy_sports.csv
#> ✔ import code pasted to clipboard!
```

``` r
tidy_sports <- read.delim(file = 'data-raw/2023-12-19/2023-12-19-tidy_sports.csv', sep = ',')
```

#### AAFs vs ADRVs

The sanctions are divided into two categories:

- `analytic`: [Adverse Analytical
  Finding](https://www.usada.org/spirit-of-sport/education/alphabet-soup-results-management/#:~:text),
  AAF; *An AAF is a report from a WADA-accredited laboratory that
  identifies the presence of a prohibited substance and/or its
  metabolites or markers in a sample.*

- `non-analytic`: [Non-Analytical Anti-doping Rule
  Violation](https://www.usada.org/spirit-of-sport/education/non-analytical-anti-doping-rule-violations/)
  ADRV; *a non-analytical anti-doping rule violation does not stem from
  a positive urine or blood sample, but instead originates from, and is
  substantiated by, other evidence of doping or violations by an athlete
  or athlete support personnel.*.

#### substance/reason

The `substance_reason` column contains the details of the sanction,
which can include the following information:

1.  The name of the banned substance

2.  A description of the infraction (if non-analytic)

We will use regular expressions to identify the type of substance behind
the sanction. See the examples below:

``` r
stringr::str_view(tidy_sports$substance_reason, 
  "use \\(epo & hgh\\)", match = TRUE)
#> [649] │ erythropoietin (epo) and non-analytical: <use (epo & hgh)>
```

``` r
stringr::str_view(tidy_sports$substance_reason,
  "tampering, complicity", match = TRUE)
#> [85] │ non-analytical: <tampering, complicity>
```

## Sanction Type

Most of the non-analytic sanctions include the terms
`non-analytic`/`non-analytical`/etc., as a prefix in the
`substance_reason` column.

I can pass these terms as regular expressions to create the
`sanction_type` variable, which will contain two values:
`non-analytical` and `analytical`. I’ll save this variable in a new the
`usada_substances` dataset:

``` r
usada_substances <- dplyr::mutate(.data = tidy_sports,
    sanction_type = dplyr::case_when(
      stringr::str_detect(string = substance_reason,
        "non-analytical") ~ "non-analytical",
      !stringr::str_detect(substance_reason,
        "non-analytical") ~ "analytical",
      TRUE ~ NA_character_
    )
  )
usada_substances |>
  dplyr::count(sanction_type, sort = TRUE)
#> # A tibble: 2 × 2
#>   sanction_type      n
#>   <chr>          <int>
#> 1 analytical       504
#> 2 non-analytical   168
```

Now I can filter `usada_substances` to the `analytical` sanctions in
`sanction_type`.

## Substances

*How can I identify the single vs. multiple substances?*

Let’s take a look at four different sanctions in
`sanction_type_example`:

    #> # A tibble: 4 × 3
    #>   sport         substance_reason                                   sanction_type
    #>   <chr>         <chr>                                              <chr>        
    #> 1 swimming      non-analytical: 3 whereabouts failures             non-analytic…
    #> 2 track & field cannabinoids                                       analytical   
    #> 3 triathlon     androgenic anabolic steroid; cannabinoids; anastr… analytical   
    #> 4 track & field non-analytical: tampering, administration (iv), a… non-analytic…

We can see two analytic and two non-analytic sanctions, and each one has
a single or multiple substance/reason. Fortunately, the sanctions with
multiple items are separated by either semicolons (`;`), commas (`,`),
or a conjunction (`and`), so I can use a regular expression to separate
the items.

``` r
dplyr::mutate(sanction_type_example,
  substance_cat = case_when(
    # identify the multiple_sr substances using a regular expression
    stringr::str_detect(substance_reason, "; |, | and | & | / ") ~ 'multiple',
    # negate the regular expression for the single substances
    !stringr::str_detect(substance_reason, "; |, | and | & | / ") ~ 'single',
    TRUE ~ NA_character_)) |>
  dplyr::count(substance_cat, sanction_type) |> 
  tidyr::pivot_wider(names_from = substance_cat, values_from = n)
#> # A tibble: 2 × 3
#>   sanction_type  multiple single
#>   <chr>             <int>  <int>
#> 1 analytical            1      1
#> 2 non-analytical        1      1
```

The `substance_cat` identifier can be used to separate sanctions with
multiple substance/reasons from sanctions with a single substance or
reason.

``` r
usada_substances <- usada_substances |>
  dplyr::mutate(substance_cat = dplyr::case_when(
    stringr::str_detect(substance_reason, "; |, | and | & | / ") ~ 'multiple',
    !stringr::str_detect(substance_reason, "; |, | and | & | / ") ~ 'single',
    TRUE ~ NA_character_))
usada_substances |> 
  dplyr::count(substance_cat, sort = TRUE)
#> # A tibble: 2 × 2
#>   substance_cat     n
#>   <chr>         <int>
#> 1 single          488
#> 2 multiple        184
```

### Single analytic substances

First we’ll focus on the sanctions with a single substance listed (we
will deal with multiple substances next).

``` r
single_analytic_substances <- usada_substances |>
  dplyr::filter(substance_cat == 'single' & sanction_type == "analytical")
head(single_analytic_substances)
#> # A tibble: 6 × 11
#>   athlete sport substance_reason sanction_terms sanction_announced sanction_date
#>   <chr>   <chr> <chr>            <chr>          <chr>              <chr>        
#> 1 park, … weig… chlorthalidone   public warning 12/11/2023         2023-12-11   
#> 2 cutro-… judo  anabolic agent   2-year suspen… 09/19/2023         2023-09-19   
#> 3 saint … mixe… 3α-hydroxy-5α-a… 6-month suspe… 09/18/2023         2023-09-18   
#> 4 wilson… trac… canrenone        public warning 09/18/2023         2023-09-18   
#> 5 casey,… mixe… bpc-157          4-month suspe… 09/14/2023         2023-09-14   
#> 6 taylor… powe… cannabinoids     3-month suspe… 09/11/2023         2023-09-11   
#> # ℹ 5 more variables: support_personnel <lgl>, paralympic <lgl>,
#> #   multiple_sports <lgl>, sanction_type <chr>, substance_cat <chr>
```

### Classifying substances with `classify_wada_substances()`

To identify the [WADA banned
substances](https://www.wada-ama.org/en/prohibited-list#search-anchor),
I’ve written `classify_wada_substances()`, a function that scans the
`substance_reason` column and identifies any substances found on the
[WADA
list](https://www.wada-ama.org/sites/default/files/2022-09/2023list_en_final_9_september_2022.pdf).
See the `classify_wada_substances()` documentation for more information.

#### How `classify_wada_substances()` works (S1 ANABOLIC AGENTS example)

`classify_wada_substances()` creates a `substance_group` variable with
each of the WADA classifications (these are stored in
`dopingdata::wada_classes`)

``` r
dopingdata::wada_classes
#> # A tibble: 13 × 1
#>    Classification                       
#>    <chr>                                
#>  1 S1 ANABOLIC AGENTS                   
#>  2 S2 PEP HORMONES/G FACTORS/MIMETICS   
#>  3 S3 BETA-2 AGONISTS                   
#>  4 S4 HORMONE AND METABOLIC MODULATORS  
#>  5 S5 DIURETICS/MASKING AGENTS          
#>  6 S6 STIMULANTS                        
#>  7 S7 NARCOTICS                         
#>  8 S8 CANNABINOIDS                      
#>  9 S9 GLUCOCORTICOIDS                   
#> 10 M1 MANIPULATION OF BLOOD             
#> 11 M2 CHEMICAL AND PHYSICAL MANIPULATION
#> 12 M3 GENE AND CELL DOPING              
#> 13 P1 BETA-BLOCKERS
```

`dopingdata` stores vectors with each substance group in the WADA list
(S1 substances are below):

``` r
head(dopingdata::s1_substances, 10)
#>  [1] "androgenic anabolic steroid"                    
#>  [2] "androgenic anabolic steroids"                   
#>  [3] "anabolic agent"                                 
#>  [4] "anabolic agents"                                
#>  [5] "anabolic steroid"                               
#>  [6] "anabolic steroids"                              
#>  [7] "androstenedione"                                
#>  [8] "metabolites of androstenedione"                 
#>  [9] "1-androstenediol (5α-androst-1-ene-3β,17β-diol)"
#> [10] "1-androstenedione"
```

The substance group vectors are also stored as regular expressions
(`s1_regex`), which we can use to match the `substance_reason` column
on:

``` r
stringr::str_view(string = single_analytic_substances$substance_reason,
  pattern = s1_regex, match = TRUE)
#>  [2] │ <anabolic agent>
#>  [9] │ <epitrenbolone>
#> [10] │ <dehydroepiandrosterone> (<dhea>)
#> [11] │ <testosterone>
#> [17] │ <boldenone>
#> [20] │ dehydrochlor<methyltestosterone> (<dhcmt>)
#> [22] │ <testosterone>
#> [23] │ <testosterone>
#> [27] │ <androgenic anabolic steroid>
#> [30] │ <dehydroepiandrosterone> (<dhea>)
#> [31] │ <ostarine>
#> [33] │ <anabolic agent>
#> [34] │ <dehydroepiandrosterone> (<dhea>)
#> [42] │ <dehydroepiandrosterone> (<dhea>)
#> [44] │ <androgenic anabolic steroid>
#> [46] │ <stanozolol>
#> [48] │ <ostarine>
#> [56] │ <androgenic anabolic steroid>
#> [58] │ <dehydroepiandrosterone> (<dhea>)
#> [59] │ <androgenic anabolic steroid>
#> ... and 146 more
```

The output from `classify_wada_substances()` can be used to answer
questions like: *what `substance_group`’s appear the most?*

``` r
single_analytic_substances <- classify_wada_substances(
  usada_data = single_analytic_substances,
  subs_column = substance_reason) 
single_analytic_substances |>
  dplyr::count(substance_group, sort = TRUE)
#> # A tibble: 12 × 2
#>    substance_group                         n
#>    <chr>                               <int>
#>  1 S1 ANABOLIC AGENTS                    166
#>  2 S6 STIMULANTS                          57
#>  3 S4 HORMONE AND METABOLIC MODULATORS    39
#>  4 S5 DIURETICS/MASKING AGENTS            38
#>  5 S8 CANNABINOIDS                        38
#>  6 S2 PEP HORMONES/G FACTORS/MIMETICS     18
#>  7 S3 BETA-2 AGONISTS                      9
#>  8 S9 GLUCOCORTICOIDS                      6
#>  9 UNCLASSIFIED                            6
#> 10 M1 MANIPULATION OF BLOOD                4
#> 11 S7 NARCOTICS                            2
#> 12 P1 BETA-BLOCKERS                        1
```

### Unclassified substances

The substances that were not classified using the standard WADA list can
be added with `classify_substance()`

``` r
single_analytic_substances |>
  filter(substance_group == "UNCLASSIFIED") |>
  count(substance_reason, sort = TRUE)
#> # A tibble: 6 × 2
#>   substance_reason                      n
#>   <chr>                             <int>
#> 1 3 whereabouts failures                1
#> 2 3α-hydroxy-5α-androst-1-en-17-one     1
#> 3 bpc-157                               1
#> 4 elevated t/e                          1
#> 5 insulin                               1
#> 6 methenolone                           1
```

#### Re-classifying substances

`classify_substance()` takes a `df`, `substance`, and `value`:

``` r
single_analytic_substances <- classify_substance(
  df = single_analytic_substances,
  substance = "elevated t/e",
  value = "S1 ANABOLIC AGENTS")
single_analytic_substances |>
  dplyr::filter(substance_reason == "elevated t/e") |>
  dplyr::select(substance_reason, substance_cat, substance_group)
#> # A tibble: 1 × 3
#>   substance_reason substance_cat substance_group   
#>   <chr>            <chr>         <chr>             
#> 1 elevated t/e     single        S1 ANABOLIC AGENTS
```
