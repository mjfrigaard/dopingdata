# Clean sanction dates

Clean sanction dates

## Usage

``` r
clean_dates(df, date_col, split = "updated", pattern = "original")
```

## Arguments

- df:

  processed USADA dataset with messy dates

- date_col:

  sanction date column (usually `sanction_announced`)

- split:

  regex to pass to split argument of
  [`strsplit()`](https://rdrr.io/r/base/strsplit.html) (defaults to
  `"updated"`)

- pattern:

  regex for other non-date pattern (defaults to `"original"`)

## Value

tibble with cleaned dates

## Examples

``` r
example_sanction_dates
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
