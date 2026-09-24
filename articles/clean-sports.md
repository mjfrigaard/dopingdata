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

Reproducing the `usada_dates` dataset from the [“Cleaning
dates”](https://mjfrigaard.github.io/dopingdata/articles/clean-dates.md)
article:

``` r

usada_raw <- get_sanctions_data()
usada <- process_text(raw_data = usada_raw)

bad_dates <- subset(usada,
  grepl("^original", usada[['sanction_announced']]))
good_dates <- subset(usada,
  !grepl("^original", usada[['sanction_announced']]) & sanction_announced != "")

cleaned_dates <- clean_dates(
  df = bad_dates,
  date_col = "sanction_announced",
  split = "updated",
  pattern = "original")
names(cleaned_dates)[names(cleaned_dates) == 'split_date'] <- 'sanction_date'
names(cleaned_dates)[names(cleaned_dates) == 'pattern_date'] <- 'original_date'
good_dates$sanction_date <- as.Date(x = good_dates[['sanction_announced']],
                                    format = "%m/%d/%Y")
nms <- intersect(names(cleaned_dates), names(good_dates))
usada_dates <- rbind(good_dates, cleaned_dates[nms])
str(usada_dates)
#> 'data.frame':    704 obs. of  6 variables:
#>  $ athlete           : chr  "lingafeldt, seth" "samelo do amaral, rider" "oprea, erin" "meador, laura" ...
#>  $ sport             : chr  "weightlifting" "brazilian jiu-jitsu" "triathlon" "weightlifting" ...
#>  $ substance_reason  : chr  "testosterone" "drostanolone; nandrolone; 19-norsteroids" "ostarine; lgd-4033; testosterone" "testosterone" ...
#>  $ sanction_terms    : chr  "1-year suspension; loss of results" "3-year suspension; loss of results" "5-year suspension; loss of results" "4-year suspension; loss of results" ...
#>  $ sanction_announced: chr  "09/24/2026" "09/21/2026" "09/11/2026" "09/03/2026" ...
#>  $ sanction_date     : Date, format: "2026-09-24" "2026-09-21" ...
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
#> tibble [704 × 6] (S3: tbl_df/tbl/data.frame)
#>  $ athlete           : chr [1:704] "lingafeldt, seth" "samelo do amaral, rider" "oprea, erin" "meador, laura" ...
#>  $ sport             : chr [1:704] "weightlifting" "brazilian jiu-jitsu" "triathlon" "weightlifting" ...
#>  $ substance_reason  : chr [1:704] "testosterone" "drostanolone; nandrolone; 19-norsteroids" "ostarine; lgd-4033; testosterone" "testosterone" ...
#>  $ sanction_terms    : chr [1:704] "1-year suspension; loss of results" "3-year suspension; loss of results" "5-year suspension; loss of results" "4-year suspension; loss of results" ...
#>  $ sanction_announced: chr [1:704] "09/24/2026" "09/21/2026" "09/11/2026" "09/03/2026" ...
#>  $ sanction_date     : Date[1:704], format: "2026-09-24" "2026-09-21" ...
```

We can start by counting the `sport` column:

``` r

usada_sports |> 
  dplyr::count(sport, sort = TRUE)
#> # A tibble: 74 × 2
#>    sport                          n
#>    <chr>                      <int>
#>  1 mixed martial arts           153
#>  2 weightlifting                143
#>  3 cycling                      100
#>  4 track and field               99
#>  5 brazilian jiu-jitsu           23
#>  6 triathlon                     17
#>  7 swimming                      15
#>  8 wrestling                     11
#>  9 paralympic track and field    10
#> 10 powerlifting                   7
#> # ℹ 64 more rows
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
#> 2 para track & field                                    5     NA
#> 3 paralympic track & field                             10     NA
#> 4 paralympic track & field, paralympic volleyball       1     NA
#> 5 track & field                                       102     NA
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
#> 1 brazilian jiu-jitsu                                23
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
#> # A tibble: 18 × 2
#>    sport                                           `TRUE`
#>    <chr>                                            <int>
#>  1 para alpine skiing                                   1
#>  2 para cycling                                         1
#>  3 para fencing                                         1
#>  4 para judo                                            1
#>  5 para shooting                                        1
#>  6 para swimming                                        1
#>  7 para track & field                                   5
#>  8 paralympic alpine skiing                             1
#>  9 paralympic archery                                   1
#> 10 paralympic basketball                                2
#> 11 paralympic curling                                   1
#> 12 paralympic cycling                                   4
#> 13 paralympic judo                                      4
#> 14 paralympic snowboarding                              3
#> 15 paralympic taekwondo                                 1
#> 16 paralympic track & field                            10
#> 17 paralympic track & field, paralympic volleyball      1
#> 18 paralympic triathlon                                 1
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
#> 1 bobsled and skeleton                                 3
#> 2 bobsled and skeleton, track & field                  1
#> 3 cycling, triathlon                                   2
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
#> tibble [9 × 9] (S3: tbl_df/tbl/data.frame)
#>  $ athlete           : chr [1:9] "allison, kyler" "blandford, jenna" "cruse, j.c." "schrodt, patrick \"dillon\"" ...
#>  $ sport             : chr [1:9] "bobsled and skeleton" "cycling, triathlon" "bobsled and skeleton" "bobsled and skeleton" ...
#>  $ substance_reason  : chr [1:9] "non-analytical: refusal to submit to sample collection" "non-analytical: use and possession (testosterone, hgh and oxandrolone)" "dimethylbutylamine (dmba)" "dimethylbutylamine (dmba)" ...
#>  $ sanction_terms    : chr [1:9] "4-year suspension; loss of results; sanction tolled due to retirement" "4-year suspension - loss of results" "16-month suspension - loss of results" "16-month suspension - loss of results" ...
#>  $ sanction_announced: chr [1:9] "10/09/2019" "11/28/2017" "07/20/2017" "04/06/2017" ...
#>  $ sanction_date     : Date[1:9], format: "2019-10-09" "2017-11-28" ...
#>  $ support_personnel : logi [1:9] FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ paralympic        : logi [1:9] FALSE FALSE FALSE FALSE TRUE FALSE ...
#>  $ multiple_sports   : logi [1:9] TRUE TRUE TRUE TRUE TRUE TRUE ...
single_sport_athletes <- usada_sports |> 
  dplyr::filter(multiple_sports == FALSE)
str(single_sport_athletes)
#> tibble [695 × 9] (S3: tbl_df/tbl/data.frame)
#>  $ athlete           : chr [1:695] "lingafeldt, seth" "samelo do amaral, rider" "oprea, erin" "meador, laura" ...
#>  $ sport             : chr [1:695] "weightlifting" "brazilian jiu-jitsu" "triathlon" "weightlifting" ...
#>  $ substance_reason  : chr [1:695] "testosterone" "drostanolone; nandrolone; 19-norsteroids" "ostarine; lgd-4033; testosterone" "testosterone" ...
#>  $ sanction_terms    : chr [1:695] "1-year suspension; loss of results" "3-year suspension; loss of results" "5-year suspension; loss of results" "4-year suspension; loss of results" ...
#>  $ sanction_announced: chr [1:695] "09/24/2026" "09/21/2026" "09/11/2026" "09/03/2026" ...
#>  $ sanction_date     : Date[1:695], format: "2026-09-24" "2026-09-21" ...
#>  $ support_personnel : logi [1:695] FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ paralympic        : logi [1:695] FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ multiple_sports   : logi [1:695] FALSE FALSE FALSE FALSE FALSE FALSE ...
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
#> tibble [19 × 9] (S3: tbl_df/tbl/data.frame)
#>  $ athlete           : chr [1:19] "allison, kyler" "allison, kyler" "blandford, jenna" "blandford, jenna" ...
#>  $ sport             : chr [1:19] "bobsled" "skeleton" "cycling" "triathlon" ...
#>  $ substance_reason  : chr [1:19] "non-analytical: refusal to submit to sample collection" "non-analytical: refusal to submit to sample collection" "non-analytical: use and possession (testosterone, hgh and oxandrolone)" "non-analytical: use and possession (testosterone, hgh and oxandrolone)" ...
#>  $ sanction_terms    : chr [1:19] "4-year suspension; loss of results; sanction tolled due to retirement" "4-year suspension; loss of results; sanction tolled due to retirement" "4-year suspension - loss of results" "4-year suspension - loss of results" ...
#>  $ sanction_announced: chr [1:19] "10/09/2019" "10/09/2019" "11/28/2017" "11/28/2017" ...
#>  $ sanction_date     : Date[1:19], format: "2019-10-09" "2019-10-09" ...
#>  $ support_personnel : logi [1:19] FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ paralympic        : logi [1:19] FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ multiple_sports   : logi [1:19] TRUE TRUE TRUE TRUE TRUE TRUE ...
```

Finally, combine the two datasets.

``` r

tidy_sports <- dplyr::bind_rows(single_sport_athletes, tidy_multp_sport_athletes)
str(tidy_sports)
#> tibble [714 × 9] (S3: tbl_df/tbl/data.frame)
#>  $ athlete           : chr [1:714] "lingafeldt, seth" "samelo do amaral, rider" "oprea, erin" "meador, laura" ...
#>  $ sport             : chr [1:714] "weightlifting" "brazilian jiu-jitsu" "triathlon" "weightlifting" ...
#>  $ substance_reason  : chr [1:714] "testosterone" "drostanolone; nandrolone; 19-norsteroids" "ostarine; lgd-4033; testosterone" "testosterone" ...
#>  $ sanction_terms    : chr [1:714] "1-year suspension; loss of results" "3-year suspension; loss of results" "5-year suspension; loss of results" "4-year suspension; loss of results" ...
#>  $ sanction_announced: chr [1:714] "09/24/2026" "09/21/2026" "09/11/2026" "09/03/2026" ...
#>  $ sanction_date     : Date[1:714], format: "2026-09-24" "2026-09-21" ...
#>  $ support_personnel : logi [1:714] FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ paralympic        : logi [1:714] FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ multiple_sports   : logi [1:714] FALSE FALSE FALSE FALSE FALSE FALSE ...
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
#> 'data.frame':    714 obs. of  9 variables:
#>  $ athlete           : chr  "lingafeldt, seth" "samelo do amaral, rider" "oprea, erin" "meador, laura" ...
#>  $ sport             : chr  "weightlifting" "brazilian jiu-jitsu" "triathlon" "weightlifting" ...
#>  $ substance_reason  : chr  "testosterone" "drostanolone; nandrolone; 19-norsteroids" "ostarine; lgd-4033; testosterone" "testosterone" ...
#>  $ sanction_terms    : chr  "1-year suspension; loss of results" "3-year suspension; loss of results" "5-year suspension; loss of results" "4-year suspension; loss of results" ...
#>  $ sanction_announced: chr  "09/24/2026" "09/21/2026" "09/11/2026" "09/03/2026" ...
#>  $ sanction_date     : Date, format: "2026-09-24" "2026-09-21" ...
#>  $ support_personnel : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ paralympic        : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ multiple_sports   : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
```

Verify there aren’t any duplicates (again).

``` r

tidy_sports |> 
  dplyr::count(athlete, sanction_date, sport) |> 
  dplyr::filter(n > 1)
#> # A tibble: 6 × 4
#>   athlete       sanction_date sport                        n
#>   <chr>         <date>        <chr>                    <int>
#> 1 *name removed NA            mixed martial arts           6
#> 2 *name removed NA            paralympic track & field     2
#> 3 *name removed NA            swimming                     4
#> 4 *name removed NA            track & field                9
#> 5 *name removed NA            volleyball                   2
#> 6 *name removed NA            weightlifting                3
```

We can see the multi-sport athletes are listed in `tidy_sports` (but
with one sport per row):

``` r

tidy_sports |> 
    dplyr::filter(multiple_sports == TRUE) |> 
    dplyr::select(athlete, sport)
#> # A tibble: 19 × 2
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
#> 11 "denney phillips, jessica"    cycling                 
#> 12 "denney phillips, jessica"    weightlifting           
#> 13 "flanagan, tyler"             skiing                  
#> 14 "flanagan, tyler"             snowboarding            
#> 15 "hamilton, tyler"             cycling                 
#> 16 "hamilton, tyler"             triathlon               
#> 17 "bailey, ryan"                bobsled                 
#> 18 "bailey, ryan"                skeleton                
#> 19 "bailey, ryan"                track & field
```
