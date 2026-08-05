# Cleaning dates

``` r

library(dopingdata)
```

Below we’ll fetch the live USADA sanctions data and process the text:

``` r

usada_raw <- get_sanctions_data()
usada <- process_text(raw_data = usada_raw)
```

## Dates

`sanction_announced` contains the date the sanction was announced, and
some of these contain two values (`original` and `updated`). Wrangling
these values pose some challenges because they aren’t *consistently*
messy:

``` r

bad_dates <- subset(usada,
  grepl("^original", usada[['sanction_announced']]),
  c(athlete, sanction_announced))
bad_dates
#>                    athlete                        sanction_announced
#> 18        mitchell, manteo original: 09/26/2025; updated: 02/25/2026
#> 42    qualls, robert jerry original: 06/26/2024; updated: 08/13/2025
#> 114             jha, kanak  original: 3/20/2023; updated: 12/01/2023
#> 198        prempeh, ernest original: 05/07/2019; updated: 02/04/2022
#> 201         ngetich, eliud     original: 09/03/21; updated: 01/25/22
#> 231             gehm, zach original:  11/04/2019;updated: 05/17/2021
#> 262           hudson, ryan   original 12/20/2018; updated 11/04/2020
#> 266      paparella, flavia   original: 10/19/2020updated: 01/05/2021
#> 277         murdock, vince original: 09/05/2019; updated: 08/26/2020
#> 281        rante, danielle original: 07/22/2020, updated: 11/03/2022
#> 310       werdum, fabricio   original 09/11/2018; updated 01/16/2020
#> 322         jones, stirley original: 06/17/2019; updated: 12/16/2019
#> 323               hay, amy original: 10/31/2017; updated: 12/16/2019
#> 350           orbon, joane original: 08/12/2019; updated: 09/10/2019
#> 365          ribas, amanda  original: 01/10/2018; updated 05/03/2019
#> 398     saccente, nicholas original: 02/14/2017; updated: 12/11/2018
#> 399           miyao, paulo  original: 05/10/2017;updated: 11/27/2018
#> 403 garcia del moral, luis  original: 07/10/2012;updated: 10/26/2018
#> 404        bruyneel, johan  original: 04/22/2014;updated: 10/24/2018
#> 405   celaya lazama, pedro  original: 04/22/2014;updated: 10/24/2018
#> 406            marti, jose  original: 04/22/2014;updated: 10/24/2018
#> 407         moffett, shaun   original: 04/24/2018updated: 10/19/2018
#> 415           hunter, adam original: 10/28/2016; updated: 09/26/2018
#> 494           bailey, ryan original: 08/03/2017; updated: 12/01/2017
#> 560          thomas, tammy original: 08/30/2002; updated: 02/13/2017
#> 588           tovar, oscar original: 10/28/2015; updated: 10/04/2016
#> 628       fischbach, dylan original: 12/18/2015; updated: 04/11/2016
#> 649        trafeh, mohamed original: 12/18/2014; updated: 08/25/2015
#> 852          young, jerome original: 11/10/2004; updated: 06/17/2008
```

### **clean_dates()**

I’ve written a
[`clean_dates()`](https://mjfrigaard.github.io/dopingdata/reference/clean_dates.md)
function that takes `date_col`, `split` and `pattern` arguments:

- `df` = processed USADA dataset with messy dates

- `date_col` = sanction date column (usually `sanction_announced`)

- `split` = regex to pass to split argument of
  [`strsplit()`](https://rdrr.io/r/base/strsplit.html) (defaults to
  `"updated"`)

- `pattern` = regex for other non-date pattern (defaults to
  `"original"`)

Below,
[`clean_dates()`](https://mjfrigaard.github.io/dopingdata/reference/clean_dates.md)
is demonstrated on a couple of the messy rows found above:

``` r

clean_dates(
  df = head(bad_dates, 2),
  date_col = "sanction_announced",
  split = "updated",
  pattern = "original")
#>                 athlete                        sanction_announced pattern_date
#> 18     mitchell, manteo original: 09/26/2025; updated: 02/25/2026   2025-09-26
#> 42 qualls, robert jerry original: 06/26/2024; updated: 08/13/2025   2024-06-26
#>    split_date
#> 18 2026-02-25
#> 42 2025-08-13
```

For `usada`, split the data into three `data.frame`s (`bad_dates`,
`good_dates`, and `no_dates`).

``` r

bad_dates <- subset(usada, 
  grepl("^original", usada[['sanction_announced']]))
good_dates <- subset(usada, 
  !grepl("^original", usada[['sanction_announced']]) & sanction_announced != "")
no_dates <- subset(usada,
  athlete == "*name removed" & sanction_announced == "")
```

Clean dates in `bad_dates` by splitting the bad dates on `"updated"` and
provided `"original"` as the pattern (the opposite will also work). The
`sanction_date` column will contain the correctly formatted updated
`sanction_date`.

After formatting `good_dates` and removing `original_date` column we can
combine the two with [`rbind()`](https://rdrr.io/r/base/cbind.html).

``` r

cleaned_dates <- clean_dates(
  df = bad_dates, 
  date_col = "sanction_announced", 
  split = "updated", 
  pattern = "original")
# address names 
names(cleaned_dates)[names(cleaned_dates) == 'split_date'] <- 'sanction_date'
names(cleaned_dates)[names(cleaned_dates) == 'pattern_date'] <- 'original_date'
# format good_dates
good_dates$sanction_date <- as.Date(x = good_dates[['sanction_announced']], 
                                    format = "%m/%d/%Y")
# get intersecting names 
nms <- intersect(names(cleaned_dates), names(good_dates))
# bind the two datasets 
usada_dates <- rbind(good_dates, cleaned_dates[nms])
str(usada_dates)
#> 'data.frame':    693 obs. of  6 variables:
#>  $ athlete           : chr  "miller, adam" "zilcosky, chase" "trabing, bert" "cantwell, steven" ...
#>  $ sport             : chr  "field hockey" "weightlifting" "weightlifting" "paralympic snowboarding" ...
#>  $ substance_reason  : chr  "non-analytical: 3 whereabouts failures" "amphetamine" "anastrozole; testosterone" "dehydrochlormethyltestosterone (dhcmt)" ...
#>  $ sanction_terms    : chr  "2-year suspension; loss of results" "2-year suspension; loss of results" "4-year suspension; loss of results" "6-year suspension; loss of results" ...
#>  $ sanction_announced: chr  "07/31/2026" "07/29/2026" "07/22/2026" "07/16/2026" ...
#>  $ sanction_date     : Date, format: "2026-07-31" "2026-07-29" ...
```
