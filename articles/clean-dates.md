# Cleaning dates

``` r

library(dopingdata)
```

Below we’ll import a demo dataset and process the text:

``` r

usada_raw <- read.csv(system.file("extdata", "demo", "2023-12-21-usada_raw.csv", 
                       package = "dopingdata"))
usada <- process_text(raw_data = usada_raw)
```

## Dates

`sanction_announced` contains the date the sanction was announced, and
about 30 of these contain two values (`original` and `updated`).
Wrangling these values pose some challenges because they aren’t
*consistently* messy:

``` r

subset(usada, 
  grepl("^original", usada[['sanction_announced']]), 
  c(athlete, sanction_announced))
#>                    athlete                        sanction_announced
#> 4               jha, kanak  original: 3/20/2023; updated: 12/01/2023
#> 88         prempeh, ernest original: 05/07/2019; updated: 02/04/2022
#> 91          ngetich, eliud     original: 09/03/21; updated: 01/25/22
#> 121             gehm, zach original:  11/04/2019;updated: 05/17/2021
#> 152           hudson, ryan   original 12/20/2018; updated 11/04/2020
#> 156      paparella, flavia   original: 10/19/2020updated: 01/05/2021
#> 167         murdock, vince original: 09/05/2019; updated: 08/26/2020
#> 171        rante, danielle original: 07/22/2020, updated: 11/03/2022
#> 200       werdum, fabricio   original 09/11/2018; updated 01/16/2020
#> 212         jones, stirley original: 06/17/2019; updated: 12/16/2019
#> 213               hay, amy original: 10/31/2017; updated: 12/16/2019
#> 240           orbon, joane original: 08/12/2019; updated: 09/10/2019
#> 255          ribas, amanda  original: 01/10/2018; updated 05/03/2019
#> 288     saccente, nicholas original: 02/14/2017; updated: 12/11/2018
#> 289           miyao, paulo  original: 05/10/2017;updated: 11/27/2018
#> 293 garcia del moral, luis  original: 07/10/2012;updated: 10/26/2018
#> 294        bruyneel, johan  original: 04/22/2014;updated: 10/24/2018
#> 295   celaya lazama, pedro  original: 04/22/2014;updated: 10/24/2018
#> 296            marti, jose  original: 04/22/2014;updated: 10/24/2018
#> 297         moffett, shaun   original: 04/24/2018updated: 10/19/2018
#> 305           hunter, adam original: 10/28/2016; updated: 09/26/2018
#> 384           bailey, ryan original: 08/03/2017; updated: 12/01/2017
#> 450          thomas, tammy original: 08/30/2002; updated: 02/13/2017
#> 478           tovar, oscar original: 10/28/2015; updated: 10/04/2016
#> 518       fischbach, dylan original: 12/18/2015; updated: 04/11/2016
#> 526            lea, robert original: 12/17/2015; updated: 02/25/2016
#> 539        trafeh, mohamed original: 12/18/2014; updated: 08/25/2015
#> 604      dotti, juan pablo original: 10/20/2011; updated: 06/05/2013
#> 679       oliveira, flavia  original: 04/13/2010; updated 12/10/2010
#> 742          young, jerome original: 11/10/2004; updated: 06/17/2008
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

Below is an example dataset to demonstrate how
[`clean_dates()`](https://mjfrigaard.github.io/dopingdata/reference/clean_dates.md)
works:

``` r

clean_dates(
  df = example_sanction_dates, 
  date_col = "ugly_dates", 
  split = "updated", 
  pattern = "original")
#>                   athlete                                ugly_dates
#> 1              jha, kanak  original: 3/20/2023; updated: 12/01/2023
#> 2         prempeh, ernest original: 05/07/2019; updated: 02/04/2022
#> 3          ngetich, eliud     original: 09/03/21; updated: 01/25/22
#> 4              gehm, zach original:  11/04/2019;updated: 05/17/2021
#> 5            hudson, ryan   original 12/20/2018; updated 11/04/2020
#> 6       paparella, flavia   original: 10/19/2020updated: 01/05/2021
#> 7          murdock, vince original: 09/05/2019; updated: 08/26/2020
#> 8         rante, danielle original: 07/22/2020, updated: 11/03/2022
#> 9        werdum, fabricio   original 09/11/2018; updated 01/16/2020
#> 10         jones, stirley original: 06/17/2019; updated: 12/16/2019
#> 11               hay, amy original: 10/31/2017; updated: 12/16/2019
#> 12           orbon, joane original: 08/12/2019; updated: 09/10/2019
#> 13          ribas, amanda  original: 01/10/2018; updated 05/03/2019
#> 14     saccente, nicholas original: 02/14/2017; updated: 12/11/2018
#> 15           miyao, paulo  original: 05/10/2017;updated: 11/27/2018
#> 16 garcia del moral, luis  original: 07/10/2012;updated: 10/26/2018
#> 17        bruyneel, johan  original: 04/22/2014;updated: 10/24/2018
#> 18   celaya lazama, pedro  original: 04/22/2014;updated: 10/24/2018
#> 19            marti, jose  original: 04/22/2014;updated: 10/24/2018
#> 20         moffett, shaun   original: 04/24/2018updated: 10/19/2018
#> 21           hunter, adam original: 10/28/2016; updated: 09/26/2018
#> 22           bailey, ryan original: 08/03/2017; updated: 12/01/2017
#> 23          thomas, tammy original: 08/30/2002; updated: 02/13/2017
#> 24           tovar, oscar original: 10/28/2015; updated: 10/04/2016
#> 25       fischbach, dylan original: 12/18/2015; updated: 04/11/2016
#> 26            lea, robert original: 12/17/2015; updated: 02/25/2016
#> 27        trafeh, mohamed original: 12/18/2014; updated: 08/25/2015
#> 28      dotti, juan pablo original: 10/20/2011; updated: 06/05/2013
#> 29       oliveira, flavia  original: 04/13/2010; updated 12/10/2010
#> 30          young, jerome original: 11/10/2004; updated: 06/17/2008
#>    pattern_date split_date
#> 1    2023-03-20 2023-12-01
#> 2    2019-05-07 2022-02-04
#> 3      21-09-03   22-01-25
#> 4    2019-11-04 2021-05-17
#> 5    2018-12-20 2020-11-04
#> 6    2020-10-19 2021-01-05
#> 7    2019-09-05 2020-08-26
#> 8    2020-07-22 2022-11-03
#> 9    2018-09-11 2020-01-16
#> 10   2019-06-17 2019-12-16
#> 11   2017-10-31 2019-12-16
#> 12   2019-08-12 2019-09-10
#> 13   2018-01-10 2019-05-03
#> 14   2017-02-14 2018-12-11
#> 15   2017-05-10 2018-11-27
#> 16   2012-07-10 2018-10-26
#> 17   2014-04-22 2018-10-24
#> 18   2014-04-22 2018-10-24
#> 19   2014-04-22 2018-10-24
#> 20   2018-04-24 2018-10-19
#> 21   2016-10-28 2018-09-26
#> 22   2017-08-03 2017-12-01
#> 23   2002-08-30 2017-02-13
#> 24   2015-10-28 2016-10-04
#> 25   2015-12-18 2016-04-11
#> 26   2015-12-17 2016-02-25
#> 27   2014-12-18 2015-08-25
#> 28   2011-10-20 2013-06-05
#> 29   2010-04-13 2010-12-10
#> 30   2004-11-10 2008-06-17
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
#> 'data.frame':    649 obs. of  6 variables:
#>  $ athlete           : chr  "rodriguez, daniel" "park, mariah" "frey, john" "forrest, evan" ...
#>  $ sport             : chr  "mixed martial arts" "weightlifting" "cycling" "weightlifting" ...
#>  $ substance_reason  : chr  "ostarine; lgd-4033" "chlorthalidone" "non-analytical: refusal to submit to sample collection" "boldenone; drostanolone; methandienone; nandrolone; testosterone" ...
#>  $ sanction_terms    : chr  "3-month suspenion" "public warning" "2-year suspension; loss of results" "3-year suspension; loss of results" ...
#>  $ sanction_announced: chr  "12/14/2023" "12/11/2023" "12/05/2023" "11/30/2023" ...
#>  $ sanction_date     : Date, format: "2023-12-14" "2023-12-11" ...
```
