# clean-sports

``` r
library(dopingdata)
```

``` r
if ("pak" %nin% loadedNamespaces()) {
  install.packages("pak", quiet = TRUE)
}
pkgs <- c("dplyr", "stringr", "tidyr", "forcats")
install.packages(pkgs, quiet = TRUE)
```

``` r
library(dplyr)
library(stringr)
library(tidyr)
library(forcats)
```

``` r
usada_dates <- read.csv(system.file("extdata", "demo", "2023-12-21-usada_dates.csv", 
                       package = "dopingdata"))
```

## Sports

To wrangle the sports, I’ll use packages and functions from the
`tidyverse` (`dplyr`, `stringr`, `tidyr`, etc.), but I also provide the
base R alternatives (wherever possible). `tidyverse` functions will
return a `tibble` (not a `data.frame`), which prints fewer rows to the
console.

``` r
usada_sports <- tibble::as_tibble(usada_dates)
str(usada_sports)
#> tibble [649 × 6] (S3: tbl_df/tbl/data.frame)
#>  $ athlete           : chr [1:649] "rodriguez, daniel" "park, mariah" "frey, john" "forrest, evan" ...
#>  $ sport             : chr [1:649] "mixed martial arts" "weightlifting" "cycling" "weightlifting" ...
#>  $ substance_reason  : chr [1:649] "ostarine; lgd-4033" "chlorthalidone" "non-analytical: refusal to submit to sample collection" "boldenone; drostanolone; methandienone; nandrolone; testosterone" ...
#>  $ sanction_terms    : chr [1:649] "3-month suspenion" "public warning" "2-year suspension; loss of results" "3-year suspension; loss of results" ...
#>  $ sanction_announced: chr [1:649] "12/14/2023" "12/11/2023" "12/05/2023" "11/30/2023" ...
#>  $ sanction_date     : chr [1:649] "2023-12-14" "2023-12-11" "2023-12-05" "2023-11-30" ...
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
These need a `support_personnel` identifier.

``` r
usada_sports <- dplyr::mutate(usada_sports, 
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

Convert sports like `track & field` to `track and field` to help
determine which athletes/support personnel are involved in multiple
sports.

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

Identify the multiple sports using `and` and `,` in a regular
expression.

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

### Tidy

Separate the multi-sport athletes in `usada_sports` as
`multp_sport_athletes` and single-sport athletes in
`single_sport_athletes`.

``` r
multp_sport_athletes <- usada_sports |> 
  dplyr::filter(multiple_sports == TRUE)
str(multp_sport_athletes)
#> tibble [11 × 9] (S3: tbl_df/tbl/data.frame)
#>  $ athlete           : chr [1:11] "allison, kyler" "blandford, jenna" "cruse, j.c." "schrodt, patrick \"dillon\"" ...
#>  $ sport             : chr [1:11] "bobsled and skeleton" "cycling, triathlon" "bobsled and skeleton" "bobsled and skeleton" ...
#>  $ substance_reason  : chr [1:11] "non-analytical: refusal to submit to sample collection" "non-analytical: use and possession (testosterone, hgh and oxandrolone)" "dimethylbutylamine (dmba)" "dimethylbutylamine (dmba)" ...
#>  $ sanction_terms    : chr [1:11] "4-year suspension; loss of results; sanction tolled due to retirement" "4-year suspension - loss of results" "16-month suspension - loss of results" "16-month suspension - loss of results" ...
#>  $ sanction_announced: chr [1:11] "10/09/2019" "11/28/2017" "07/20/2017" "04/06/2017" ...
#>  $ sanction_date     : chr [1:11] "2019-10-09" "2017-11-28" "2017-07-20" "2017-04-06" ...
#>  $ support_personnel : logi [1:11] FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ paralympic        : logi [1:11] FALSE FALSE FALSE FALSE TRUE FALSE ...
#>  $ multiple_sports   : logi [1:11] TRUE TRUE TRUE TRUE TRUE TRUE ...
single_sport_athletes <- usada_sports |> 
  dplyr::filter(multiple_sports == FALSE)
str(single_sport_athletes)
#> tibble [638 × 9] (S3: tbl_df/tbl/data.frame)
#>  $ athlete           : chr [1:638] "rodriguez, daniel" "park, mariah" "frey, john" "forrest, evan" ...
#>  $ sport             : chr [1:638] "mixed martial arts" "weightlifting" "cycling" "weightlifting" ...
#>  $ substance_reason  : chr [1:638] "ostarine; lgd-4033" "chlorthalidone" "non-analytical: refusal to submit to sample collection" "boldenone; drostanolone; methandienone; nandrolone; testosterone" ...
#>  $ sanction_terms    : chr [1:638] "3-month suspenion" "public warning" "2-year suspension; loss of results" "3-year suspension; loss of results" ...
#>  $ sanction_announced: chr [1:638] "12/14/2023" "12/11/2023" "12/05/2023" "11/30/2023" ...
#>  $ sanction_date     : chr [1:638] "2023-12-14" "2023-12-11" "2023-12-05" "2023-11-30" ...
#>  $ support_personnel : logi [1:638] FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ paralympic        : logi [1:638] FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ multiple_sports   : logi [1:638] FALSE FALSE FALSE FALSE FALSE FALSE ...
```

The athletes listed with multiple sports will occupy multiple rows in a
‘tidy’ version of `usada_sports`.

- Passing the sport column to
  [`tidyr::separate_rows()`](https://tidyr.tidyverse.org/reference/separate_rows.html)
  and
  [`stringr::str_trim()`](https://stringr.tidyverse.org/reference/str_trim.html)
  in `multp_sport_athletes` will create a `tidy_multp_sport_athletes`
  dataset:

``` r
tidy_multp_sport_athletes <- multp_sport_athletes |> 
  tidyr::separate_rows(sport, sep = "and|, ") |> 
  dplyr::mutate(sport = stringr::str_trim(sport, side = "both"))
str(tidy_multp_sport_athletes)
#> tibble [23 × 9] (S3: tbl_df/tbl/data.frame)
#>  $ athlete           : chr [1:23] "allison, kyler" "allison, kyler" "blandford, jenna" "blandford, jenna" ...
#>  $ sport             : chr [1:23] "bobsled" "skeleton" "cycling" "triathlon" ...
#>  $ substance_reason  : chr [1:23] "non-analytical: refusal to submit to sample collection" "non-analytical: refusal to submit to sample collection" "non-analytical: use and possession (testosterone, hgh and oxandrolone)" "non-analytical: use and possession (testosterone, hgh and oxandrolone)" ...
#>  $ sanction_terms    : chr [1:23] "4-year suspension; loss of results; sanction tolled due to retirement" "4-year suspension; loss of results; sanction tolled due to retirement" "4-year suspension - loss of results" "4-year suspension - loss of results" ...
#>  $ sanction_announced: chr [1:23] "10/09/2019" "10/09/2019" "11/28/2017" "11/28/2017" ...
#>  $ sanction_date     : chr [1:23] "2019-10-09" "2019-10-09" "2017-11-28" "2017-11-28" ...
#>  $ support_personnel : logi [1:23] FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ paralympic        : logi [1:23] FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ multiple_sports   : logi [1:23] TRUE TRUE TRUE TRUE TRUE TRUE ...
```

Finally, combine the two datasets.

``` r
tidy_sports <- dplyr::bind_rows(single_sport_athletes, tidy_multp_sport_athletes)
str(tidy_sports)
#> tibble [661 × 9] (S3: tbl_df/tbl/data.frame)
#>  $ athlete           : chr [1:661] "rodriguez, daniel" "park, mariah" "frey, john" "forrest, evan" ...
#>  $ sport             : chr [1:661] "mixed martial arts" "weightlifting" "cycling" "weightlifting" ...
#>  $ substance_reason  : chr [1:661] "ostarine; lgd-4033" "chlorthalidone" "non-analytical: refusal to submit to sample collection" "boldenone; drostanolone; methandienone; nandrolone; testosterone" ...
#>  $ sanction_terms    : chr [1:661] "3-month suspenion" "public warning" "2-year suspension; loss of results" "3-year suspension; loss of results" ...
#>  $ sanction_announced: chr [1:661] "12/14/2023" "12/11/2023" "12/05/2023" "11/30/2023" ...
#>  $ sanction_date     : chr [1:661] "2023-12-14" "2023-12-11" "2023-12-05" "2023-11-30" ...
#>  $ support_personnel : logi [1:661] FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ paralympic        : logi [1:661] FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ multiple_sports   : logi [1:661] FALSE FALSE FALSE FALSE FALSE FALSE ...
```

### **clean_sports()**

These steps are combined in the
[`clean_sports()`](https://mjfrigaard.github.io/dopingdata/reference/clean_sports.md)
function:

``` r
str(
  clean_sports(
    df = usada_dates, 
    sport_col = "sport", 
    tidy = TRUE)
)
#> 'data.frame':    661 obs. of  9 variables:
#>  $ athlete           : chr  "rodriguez, daniel" "park, mariah" "frey, john" "forrest, evan" ...
#>  $ sport             : chr  "mixed martial arts" "weightlifting" "cycling" "weightlifting" ...
#>  $ substance_reason  : chr  "ostarine; lgd-4033" "chlorthalidone" "non-analytical: refusal to submit to sample collection" "boldenone; drostanolone; methandienone; nandrolone; testosterone" ...
#>  $ sanction_terms    : chr  "3-month suspenion" "public warning" "2-year suspension; loss of results" "3-year suspension; loss of results" ...
#>  $ sanction_announced: chr  "12/14/2023" "12/11/2023" "12/05/2023" "11/30/2023" ...
#>  $ sanction_date     : chr  "2023-12-14" "2023-12-11" "2023-12-05" "2023-11-30" ...
#>  $ support_personnel : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ paralympic        : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ multiple_sports   : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
```

Verify there aren’t any duplicates (again).

``` r
tidy_sports |> 
  dplyr::count(athlete, sanction_date, sport) |> 
  dplyr::filter(n > 1)
#> # A tibble: 0 × 4
#> # ℹ 4 variables: athlete <chr>, sanction_date <chr>, sport <chr>, n <int>
```

We can see the multi-sport athletes are listed in `tidy_sports` (but
with one sport per row):

``` r
tidy_sports |> 
    dplyr::filter(multiple_sports == TRUE) |> 
    dplyr::select(athlete, sport)
#> # A tibble: 23 × 2
#>    athlete                       sport                   
#>    <chr>                         <chr>                   
#>  1 "allison, kyler"              bobsled                 
#>  2 "allison, kyler"              skeleton                
#>  3 "blandford, jenna"            cycling                 
#>  4 "blandford, jenna"            triathlon               
#>  5 "cruse, j.c."                 bobsled                 
#>  6 "cruse, j.c."                 skeleton                
#>  7 "schrodt, patrick \"dillon\"" bobsled                 
#>  8 "schrodt, patrick \"dillon\"" skeleton                
#>  9 "green, roderick"             paralympic track & field
#> 10 "green, roderick"             paralympic volleyball   
#> # ℹ 13 more rows
```
