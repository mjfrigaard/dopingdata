# Classifying substances

``` r

library(dopingdata)
```

``` r

if ("pak" %nin% loadedNamespaces()) {
  install.packages("pak", quiet = TRUE)
}
pkgs <- c("dplyr", "stringr", "tidyr", "forcats")
pak::pak(pkgs)
```

``` r

library(dplyr)
library(stringr)
library(tidyr)
library(forcats)
```

This vignette covers classifying ‘adverse analytic findings’ for a
single banned substance. Reproducing the `tidy_sports` dataset from the
[“clean-sports”](https://mjfrigaard.github.io/dopingdata/articles/clean-sports.md)
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

tidy_sports <- clean_sports(df = usada_dates, sport_col = "sport", tidy = TRUE)
str(tidy_sports)
#> 'data.frame':    703 obs. of  9 variables:
#>  $ athlete           : chr  "miller, adam" "zilcosky, chase" "trabing, bert" "cantwell, steven" ...
#>  $ sport             : chr  "field hockey" "weightlifting" "weightlifting" "paralympic snowboarding" ...
#>  $ substance_reason  : chr  "non-analytical: 3 whereabouts failures" "amphetamine" "anastrozole; testosterone" "dehydrochlormethyltestosterone (dhcmt)" ...
#>  $ sanction_terms    : chr  "2-year suspension; loss of results" "2-year suspension; loss of results" "4-year suspension; loss of results" "6-year suspension; loss of results" ...
#>  $ sanction_announced: chr  "07/31/2026" "07/29/2026" "07/22/2026" "07/16/2026" ...
#>  $ sanction_date     : Date, format: "2026-07-31" "2026-07-29" ...
#>  $ support_personnel : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ paralympic        : logi  FALSE FALSE FALSE TRUE FALSE FALSE ...
#>  $ multiple_sports   : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
```

## AAFs vs ADRVs

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

### Substance/reason

The `substance_reason` column contains the details of the sanction,
which can include the following information:

1.  The name of the banned substance

2.  A description of the infraction (if non-analytic)

We will use regular expressions to identify the type of substance behind
the sanction. See the examples below:

``` r

stringr::str_view(tidy_sports[['substance_reason']], 
  "use \\(epo & hgh\\)", match = TRUE)
#> [684] │ erythropoietin (epo) and non-analytical: <use (epo & hgh)>
```

``` r

stringr::str_view(tidy_sports[['substance_reason']],
  "tampering, complicity", match = TRUE)
#> [195] │ non-analytical: <tampering, complicity>
```

Most of the non-analytic sanctions include the terms
`non-analytic`/`non-analytical`/etc., as a prefix in the
`substance_reason` column.

### Sanction types

I can pass these terms as regular expressions to create the
`sanction_type` variable, which will contain two values: `non-analytic`
and `analytic`. I’ll save this variable in a new intermediate
`substances` dataset:

``` r

substances <- dplyr::mutate(.data = tidy_sports,
    sanction_type = dplyr::case_when(
      stringr::str_detect(string = substance_reason,
        "non-analytical") ~ "non-analytic",
      !stringr::str_detect(substance_reason,
        "non-analytical") ~ "analytic",
      TRUE ~ NA_character_
    )
  )
substances |>
  dplyr::count(sanction_type, sort = TRUE)
#>   sanction_type   n
#> 1      analytic 548
#> 2  non-analytic 155
```

Now I can filter `substances` to the `analytical` sanctions in
`sanction_type`.

#### *How can I identify the single vs. multiple substances?*

Let’s take a look at four different sanctions, pulled from the live data
(one for each combination of `sanction_type` and single vs. multiple
substance/reason):

``` r

substance_type_examples <- substances |>
  dplyr::mutate(substance_cat = dplyr::if_else(
    stringr::str_detect(substance_reason, "; |, | and | & | / "),
    "multiple", "single")) |>
  dplyr::group_by(sanction_type, substance_cat) |>
  dplyr::slice_head(n = 1) |>
  dplyr::ungroup() |>
  dplyr::select(athlete, substance_reason, sanction_type, substance_cat)
substance_type_examples
#> # A tibble: 4 × 4
#>   athlete               substance_reason             sanction_type substance_cat
#>   <chr>                 <chr>                        <chr>         <chr>        
#> 1 trabing, bert         anastrozole; testosterone    analytic      multiple     
#> 2 zilcosky, chase       amphetamine                  analytic      single       
#> 3 anmaw mengesha, adane non-analytical: use (intrav… non-analytic  multiple     
#> 4 miller, adam          non-analytical: 3 whereabou… non-analytic  single
```

### Substance category

We can see analytic and non-analytic sanctions, with both single and
multiple substance/reason. Fortunately, the sanctions with multiple
items are separated by either semicolons (`;`), commas (`,`), or a
conjunction (`and`), and can be separated by a regular expression:

``` r

dplyr::mutate(substance_type_examples,
  substance_cat = dplyr::case_when(
    # identify the multiple_sr substances using a regular expression
    stringr::str_detect(substance_reason, "; |, | and | & | / ") ~ 'multiple',
    # negate the regular expression for the single substances
    !stringr::str_detect(substance_reason, "; |, | and | & | / ") ~ 'single',
    TRUE ~ NA_character_)) |>
  dplyr::count(substance_cat, substance_reason) |>
  tidyr::pivot_wider(names_from = substance_cat, values_from = n)
#> # A tibble: 4 × 3
#>   substance_reason                                      multiple single
#>   <chr>                                                    <int>  <int>
#> 1 anastrozole; testosterone                                    1     NA
#> 2 non-analytical: use (intravenous infusion); tampering        1     NA
#> 3 amphetamine                                                 NA      1
#> 4 non-analytical: 3 whereabouts failures                      NA      1
```

The `substance_cat` identifier can be used to separate sanctions with
multiple substance/reasons from sanctions with a single substance or
reason.

``` r

substances <- substances |>
  dplyr::mutate(substance_cat = dplyr::case_when(
    stringr::str_detect(substance_reason, "; |, | and | & | / ") ~ 'multiple',
    !stringr::str_detect(substance_reason, "; |, | and | & | / ") ~ 'single',
    TRUE ~ NA_character_))
substances |> 
  dplyr::count(substance_cat, sort = TRUE)
#>   substance_cat   n
#> 1        single 522
#> 2      multiple 181
```

## Single analytic substances

First create a dataset that contains the sanctions with a *single*
substance listed. Store these in `single_analytic_substances`.

``` r

single_analytic_substances <- substances |>
  dplyr::filter(substance_cat == 'single' & sanction_type == "analytic")
```

View the top ten single analytic substances:

``` r

single_analytic_substances |> 
  dplyr::count(substance_reason, sort = TRUE) |> 
  head(10)
#>                 substance_reason  n
#> 1    androgenic anabolic steroid 46
#> 2                   cannabinoids 45
#> 3                       ostarine 40
#> 4                     clomiphene 22
#> 5                      meldonium 14
#> 6                   testosterone 14
#> 7  dehydroepiandrosterone (dhea) 11
#> 8                     stanozolol 11
#> 9                    clenbuterol 10
#> 10                    furosemide 10
```

## Multiple analytic substances

Next create a dataset with the sanctions listing *multiple* substances
in `substance_reason`. Store these in `multiple_analytic_substances`.

``` r

multiple_analytic_substances <- substances |>
  dplyr::filter(substance_cat == 'multiple' & sanction_type == "analytic")
```

View the top ten multiple analytic substances:

``` r

multiple_analytic_substances |> 
  dplyr::count(substance_reason, sort = TRUE) |> 
  head(10)
#>                                                                           substance_reason
#> 1                                                                       ostarine; lgd-4033
#> 2                                                            clomiphene and its metabolite
#> 3                                 androgenic anabolic steroid & 19-norandrosterone (19-na)
#> 4                                                       benzoylecgonine and methylecgonine
#> 5                                                               ostarine; lgd-4033; gw1516
#> 6                                                                 stanozolol; drostanolone
#> 7                                                     1-androstenedione and its metabolite
#> 8                                                     1-testosterone and 1-androstenedione
#> 9  19-norandrosterone (19-na), 19-noretiocholanolone, and drostanolone and its metabolites
#> 10         19-norandrosterone (19-na), drostanolone and its metabolites, and epitrenbolone
#>    n
#> 1  4
#> 2  3
#> 3  2
#> 4  2
#> 5  2
#> 6  2
#> 7  1
#> 8  1
#> 9  1
#> 10 1
```

### Tidying substances

Tidying the sanctions with multiple [WADA banned
substances](https://www.wada-ama.org/en/prohibited-list?q) (i.e., one
substance per athlete per row) will result in certain athletes appearing
in the dataset more than once. The regular expressions below cover a
range of semicolons, tabs, and spaces to identify and separate each
substance.

#### add_match_col()

> *I’ve written the
> [`add_match_col()`](https://mjfrigaard.github.io/dopingdata/reference/add_match_col.md)
> function, which creates a new `'matched'` column with the matched
> regular expression pattern (it’s like
> [`stringr::str_view()`](https://stringr.tidyverse.org/reference/str_view.html),
> but in a `data.frame`/`tibble`). I used
> [`add_match_col()`](https://mjfrigaard.github.io/dopingdata/reference/add_match_col.md)
> while determining the correct pattern to match on (i.e., any
> substances listing `metabolites`):*

``` r

dplyr::mutate(substance_type_examples,
  # add matched column
  punct_match = add_match_col(
    string = substance_reason,
    pattern = "[[:punct:]]")) |>
  dplyr::select(substance_reason, dplyr::last_col())
#> # A tibble: 4 × 2
#>   substance_reason                                      punct_match  
#>   <chr>                                                 <chr>        
#> 1 anastrozole; testosterone                             ;            
#> 2 amphetamine                                           NA           
#> 3 non-analytical: use (intravenous infusion); tampering -, :, (, ), ;
#> 4 non-analytical: 3 whereabouts failures                -, :
```

> *The rows above are all matching correctly on the regular expression
> pattern.*

Below are a series of regular expression to 1) match the substances that
list `metabolites` 2) differentiate the multiple substances, and 3)
trims the white space from the tidy `substance_reason` column.

The code below tests this pattern on a sample from
`multiple_analytic_substances` before its passed to
[`tidyr::separate_rows()`](https://tidyr.tidyverse.org/reference/separate_rows.html):

``` r

dplyr::sample_n(multiple_analytic_substances, size = 10, replace = FALSE) |> 
  dplyr::mutate(
    # replace plurals
      substance_reason = stringr::str_replace_all(substance_reason,
        "and its metabolite|and its metabolites|its metabolite",
        "(metabolite)")) |> 
    tidyr::separate_rows(substance_reason, 
        sep = "; |;\t|\\t|, |;| and |and a |and | & | / ") |> 
    dplyr::mutate(substance_reason = trimws(substance_reason, "both")) |> 
    dplyr::select(athlete, substance_reason)
#> # A tibble: 30 × 2
#>    athlete                substance_reason                   
#>    <chr>                  <chr>                              
#>  1 romero noboa, isidro   androgenic anabolic steroid        
#>  2 romero noboa, isidro   cannabinoids                       
#>  3 romero noboa, isidro   anastrozole                        
#>  4 romero noboa, isidro   clomiphene                         
#>  5 romero noboa, isidro   gw1516                             
#>  6 cardoso, josé henrique 19-norandrosterone (19-na)         
#>  7 cardoso, josé henrique 2a-methyl-5a-androstan-3a-ol-17-one
#>  8 cardoso, josé henrique epitrenbolone                      
#>  9 cardoso, josé henrique methasterone                       
#> 10 cardoso, josé henrique testosterone                       
#> # ℹ 20 more rows
```

After confirming the pattern is working, the output will be stored in
`tidy_multiple_substances`.

``` r

tidy_multiple_substances <- dplyr::mutate(multiple_analytic_substances,
  # replace plurals
    substance_reason = stringr::str_replace_all(substance_reason,
      "and its metabolite|and its metabolites|its metabolite",
      "(metabolite)")) |> 
  tidyr::separate_rows(substance_reason, 
      sep = "; |;\t|\\t|, |;| and |and a |and | & | / ") |> 
  dplyr::mutate(substance_reason = trimws(substance_reason, "both"))
```

With both single and multiple substances in tidy format, they can be
combined together into a single `tidy_substances` dataset.

``` r

tidy_substances <- rbind(single_analytic_substances, tidy_multiple_substances) 
```

The top 10 tidy substances are below:

``` r

tidy_substances |> 
  dplyr::count(substance_reason, sort = TRUE) |> 
  head(10)
#>               substance_reason  n
#> 1                     ostarine 67
#> 2  androgenic anabolic steroid 60
#> 3                 cannabinoids 47
#> 4                   clomiphene 36
#> 5                 testosterone 29
#> 6                       gw1516 20
#> 7          hydrochlorothiazide 17
#> 8                   stanozolol 16
#> 9                     lgd-4033 15
#> 10                 clenbuterol 14
```

## classify_wada_substances()

To identify the [WADA banned
substances](https://www.wada-ama.org/en/prohibited-list#search-anchor),
I’ve written
[`classify_wada_substances()`](https://mjfrigaard.github.io/dopingdata/reference/classify_wada_substances.md),
a function that scans the `substance_reason` column and identifies any
substances found on the [WADA
list](https://www.wada-ama.org/sites/default/files/2022-09/2023list_en_final_9_september_2022.pdf).
See the
[`classify_wada_substances()`](https://mjfrigaard.github.io/dopingdata/reference/classify_wada_substances.md)
documentation for more information.

### WADA Classes

[`classify_wada_substances()`](https://mjfrigaard.github.io/dopingdata/reference/classify_wada_substances.md)
creates a `substance_group` variable with each of the WADA
classifications (stored in `dopingdata::wada_classes`):

``` r

dopingdata::wada_classes
#>                           Classification
#> 1                     S1 ANABOLIC AGENTS
#> 2     S2 PEP HORMONES/G FACTORS/MIMETICS
#> 3                     S3 BETA-2 AGONISTS
#> 4    S4 HORMONE AND METABOLIC MODULATORS
#> 5            S5 DIURETICS/MASKING AGENTS
#> 6                          S6 STIMULANTS
#> 7                           S7 NARCOTICS
#> 8                        S8 CANNABINOIDS
#> 9                     S9 GLUCOCORTICOIDS
#> 10              S0 UNAPPROVED SUBSTANCES
#> 11              M1 MANIPULATION OF BLOOD
#> 12 M2 CHEMICAL AND PHYSICAL MANIPULATION
#> 13               M3 GENE AND CELL DOPING
#> 14                      P1 BETA-BLOCKERS
```

`dopingdata` stores vectors with each substance group in the WADA list
(the `S1 ANABOLIC AGENTS` substances are below):

``` r

head(dopingdata::s1_substances, 10)
#>  [1] "3α-hydroxy-5α-androst-1-en-17-one"              
#>  [2] "androgenic anabolic steroid"                    
#>  [3] "androgenic anabolic steroids"                   
#>  [4] "anabolic agent"                                 
#>  [5] "anabolic agents"                                
#>  [6] "anabolic steroid"                               
#>  [7] "anabolic steroids"                              
#>  [8] "androstenedione"                                
#>  [9] "metabolites of androstenedione"                 
#> [10] "1-androstenediol (5α-androst-1-ene-3β,17β-diol)"
```

The substance group vectors are passed to make_regex() to create a
regular expressions (`s1_regex`), which we can use to match the
`substance_reason` column on (see the example using the live
`tidy_substances` dataset built above):

``` r

s1_regex <- make_regex(x = dopingdata::s1_substances, wb = TRUE)
stringr::str_view(string = tidy_substances$substance_reason,
  pattern = s1_regex, match = TRUE)
#>  [2] │ dehydrochlormethyltestosterone (<dhcmt>)
#>  [6] │ <testosterone>
#>  [7] │ <dehydroepiandrosterone> (<dhea>)
#>  [9] │ <dehydroepiandrosterone> (<dhea>)
#> [11] │ <androgenic anabolic steroid>
#> [20] │ <androgenic anabolic steroid>
#> [23] │ <dehydroepiandrosterone> (<dhea>)
#> [24] │ <testosterone>
#> [25] │ <testosterone>
#> [26] │ <testosterone>
#> [28] │ <dehydroepiandrosterone> (<dhea>)
#> [31] │ <ostarine>
#> [33] │ <drostanolone>
#> [34] │ <androgenic anabolic steroid>
#> [38] │ <ostarine>
#> [40] │ <metenolone>
#> [42] │ <androgenic anabolic steroid>
#> [43] │ <oxandrolone>
#> [46] │ <ostarine>
#> [47] │ <19-norandrosterone>
#> ... and 347 more
```

The output from
[`classify_wada_substances()`](https://mjfrigaard.github.io/dopingdata/reference/classify_wada_substances.md)
can be used to answer questions like: *what `substance_group`’s appear
the most?*

``` r

tidy_substances <- classify_wada_substances(
  usada_data = tidy_substances,
  subs_column = "substance_reason") 
```

### **UNCLASSIFIED** single substances

The following `single` substances are marked as `UNCLASSIFIED`:

``` r

tidy_substances |>
  dplyr::filter(
      substance_cat == "single" & 
      substance_group == "UNCLASSIFIED" & 
      substance_reason != "") |>
  dplyr::distinct(athlete, substance_reason)
#>             athlete                         substance_reason
#> 1     *name removed                              dorzolamide
#> 2 brinegar, michael erythropoietic stimulating agents (esas)
#> 3   mcmahon, kensey                               vadadustat
#> 4     *name removed                             capromorelin
#> 5    sundeen, tyler                           ritalinic acid
#> 6   rodriguez, yair                   3 whereabouts failures
```

The final unclassified substance is actually a result from a
miss-classified sanction type (for `rodriguez, yair`).

``` r

tidy_substances |>
  dplyr::filter(athlete == "rodriguez, yair") |>
  dplyr::select(athlete, substance_reason, substance_group, sanction_type)
#>           athlete       substance_reason substance_group sanction_type
#> 1 rodriguez, yair 3 whereabouts failures    UNCLASSIFIED      analytic
```

For this particular athlete, 1) the `sanction_type` should be
`non-analytic`, and 2) the `substance_group` should be missing
(`NA_character_`)

``` r

tidy_substances <- tidy_substances |>
  dplyr::mutate(sanction_type = dplyr::case_when(
    athlete == "rodriguez, yair" ~ "non-analytic",
    TRUE ~ sanction_type
  )) |> 
  dplyr::mutate(substance_group = dplyr::case_when(
    athlete == "rodriguez, yair" ~ NA_character_,
    TRUE ~ substance_group
  )) 
tidy_substances |>
  dplyr::filter(athlete == "rodriguez, yair") |>
  dplyr::select(athlete, substance_reason, substance_group, sanction_type)
#>           athlete       substance_reason substance_group sanction_type
#> 1 rodriguez, yair 3 whereabouts failures            <NA>  non-analytic
```

### **UNCLASSIFIED** multiple substances

``` r

tidy_substances |>
  dplyr::filter(
      substance_cat == "multiple" & 
      substance_group == "UNCLASSIFIED" & 
      substance_reason != "") |>
  dplyr::distinct(substance_reason)
#>                                                       substance_reason
#> 1                                                                 hctz
#> 2                                                              rad-140
#> 3                                  2a-methyl-5a-androstan-3a-ol-17-one
#> 4                                                    d-methamphetamine
#> 5                                                           arimistane
#> 6                                                           torasemide
#> 7                                                           possession
#> 8                                                    use/attempted use
#> 9                                            evading sample collection
#> 10                                                               igf-1
#> 11                                  human chorionic gonadotropin (hcg)
#> 12                                                            aod-9064
#> 13                                                                s-23
#> 14                           intact human chorionic gonadtrophin (hcg)
#> 15 thiazide metabolite 4-amino-6-chloro-1,3-benzenedisulfonamide (acb)
#> 16                                                      methylecgonine
#> 17                                                     propylhexadrine
#> 18                                                 androstatrienedione
#> 19                                             androst-(2,3)-en-17-one
#> 20                                      non-anatlyical: administration
#> 21                                                         trafficking
#> 22                                 human chorionic gonadotrophin (hcg)
#> 23                                violation of period of ineligibility
```

## Re-classifying substances

Any substances that are not classified from the existing WADA list can
be added with
[`reclass_substance()`](https://mjfrigaard.github.io/dopingdata/reference/reclass_substance.md)
(these substances can also added to their relative vector and regular
expression in `data-raw/`)

### **reclass_substance()**

[`reclass_substance()`](https://mjfrigaard.github.io/dopingdata/reference/reclass_substance.md)
takes a `df`, `substance`, and `value`:

``` r

# 2a-methyl-5a-androstan-3a-ol-17-one ----
# https://www.wada-ama.org/en/prohibited-list?page=0&q=arimistane&all=1#search-anchor
tidy_substances <- reclass_substance(
  df = tidy_substances,
  substance = "^2a-methyl-5a-androstan-3a-ol-17-one$",
  value = "S1 ANABOLIC AGENTS")
# d-methamphetamine ----
# https://www.usada.org/sanction/hillary-tran-accepts-doping-sanction/
tidy_substances <- reclass_substance(
  df = tidy_substances,
  substance = "d-methamphetamine",
  value = "S6 STIMULANTS")
# arimistane ----
# https://www.wada-ama.org/en/prohibited-list?page=0&q=arimistane&all=1#search-anchor
tidy_substances <- reclass_substance(
  df = tidy_substances,
  substance = "arimistane",
  value = "S4 HORMONE AND METABOLIC MODULATORS")
# torasemide ----
# https://www.wada-ama.org/en/prohibited-list?page=0&q=torasemide&all=1#search-anchor
tidy_substances <- reclass_substance(
  df = tidy_substances,
  substance = "torasemide",
  value = "S5 DIURETICS/MASKING AGENTS")
# igf-1 ----
# https://www.wada-ama.org/en/prohibited-list?page=0&q=igf-1&all=1#search-anchor
tidy_substances <- reclass_substance(
  df = tidy_substances,
  substance = "igf-1",
  value = "S2 PEP HORMONES/G FACTORS/MIMETICS")
# human chorionic gonadotropin (hcg)  ----
# https://www.usada.org/athletes/antidoping101/athlete-guide-anti-doping/
# https://www.usada.org/spirit-of-sport/education/wellness-and-anti-aging-clinics/
tidy_substances <- reclass_substance(
  df = tidy_substances,
  substance = "^human chorionic gonadotropin \\(hcg\\)$",
  value = "S2 PEP HORMONES/G FACTORS/MIMETICS")
# intact human chorionic gonadtrophin (hcg)  ----
# https://www.usada.org/athletes/antidoping101/athlete-guide-anti-doping/
tidy_substances <- reclass_substance(
  df = tidy_substances,
  substance = "^intact human chorionic gonadtrophin \\(hcg\\)$",
  value = "S2 PEP HORMONES/G FACTORS/MIMETICS")
# human chorionic gonadotrophin (hcg)  ----
# https://www.usada.org/athletes/antidoping101/athlete-guide-anti-doping/
tidy_substances <- reclass_substance(
  df = tidy_substances,
  substance = "human chorionic gonadotrophin \\(hcg\\)",
  value = "S2 PEP HORMONES/G FACTORS/MIMETICS")
# aod-9064  ----
# https://www.wada-ama.org/en/prohibited-list?page=0&q=aod-9064&all=1#search-anchor
tidy_substances <- reclass_substance(
  df = tidy_substances,
  substance = "aod-9064",
  value = "S2 PEP HORMONES/G FACTORS/MIMETICS")
# s-23  ----
# https://www.wada-ama.org/en/prohibited-list?page=0&q=s-23&all=1#search-anchor
tidy_substances <- reclass_substance(
  df = tidy_substances,
  substance = "s-23",
  value = "S1 ANABOLIC AGENTS")
# methenolone  ----
# https://www.wada-ama.org/en/prohibited-list?page=0&q=methenolone&all=1#search-anchor
tidy_substances <- reclass_substance(
  df = tidy_substances,
  substance = "methenolone",
  value = "S1 ANABOLIC AGENTS")
# thiazide metabolite 4-amino-6-chloro-1,3-benzenedisulfonamide (acb)  ----
# https://www.wada-ama.org/en/prohibited-list?page=0&q=thiazide&all=1#search-anchor
tidy_substances <- reclass_substance(
  df = tidy_substances,
  substance = "^thiazide metabolite 4-amino-6-chloro-1,3-benzenedisulfonamide \\(acb\\)$",
  value = "S5 DIURETICS/MASKING AGENTS")
# methylecgonine  ----
# https://www.usada.org/sanction/mike-alexandrov-accepts-doping-sanction/
tidy_substances <- reclass_substance(
  df = tidy_substances,
  substance = "methylecgonine",
  value = "S6 STIMULANTS")
# propylhexadrine  ----
# https://www.wada-ama.org/en/prohibited-list?page=0&q=propylhexadrine&all=1#search-anchor
tidy_substances <- reclass_substance(
  df = tidy_substances,
  substance = "propylhexadrine",
  value = "S6 STIMULANTS")
# androstatrienedione  ----
# https://www.wada-ama.org/en/prohibited-list?page=0&q=androstatrienedione&all=1#search-anchor
tidy_substances <- reclass_substance(
  df = tidy_substances,
  substance = "androstatrienedione",
  value = "S4 HORMONE AND METABOLIC MODULATORS")
# androst-(2,3)-en-17-one  ----
# https://www.wada-ama.org/en/prohibited-list?page=0&q=androst&all=1#search-anchor
tidy_substances <- reclass_substance(
  df = tidy_substances,
  substance = "androst-\\(2,3\\)-en-17-one",
  value = "S1 ANABOLIC AGENTS")
# methylclostebol ----
# https://www.wada-ama.org/en/prohibited-list?page=0&q=methylclostebol&all=1#search-anchor
tidy_substances <- reclass_substance(
  df = tidy_substances,
  substance = "methylclostebol",
  value = "S1 ANABOLIC AGENTS")
# promagnon  ----
# https://www.usada.org/sanction/u-s-judo-athlete-ohara-accepts-sanction-rule-violation/
tidy_substances <- reclass_substance(
  df = tidy_substances,
  substance = "promagnon",
  value = "S1 ANABOLIC AGENTS")
# 4-hydroxytriamterene  ----
# 4-Hydroxy Triamterene is a diuretic agent and metabolite of Triamterene
# https://www.scbt.com/p/4-hydroxy-triamterene-1226-52-4
tidy_substances <- reclass_substance(
  df = tidy_substances,
  substance = "4-hydroxytriamterene",
  value = "S5 DIURETICS/MASKING AGENTS")
```

After reclassifying the substances above, remaining
`UNCLASSIFIED`/`multiple` sanctions are all non-analytic:

``` r

tidy_substances |>
  dplyr::filter(
      substance_cat == "multiple" & 
      substance_group == "UNCLASSIFIED" & 
      substance_reason != "") |>
  dplyr::distinct(substance_reason) 
#>                       substance_reason
#> 1                                 hctz
#> 2                              rad-140
#> 3                           possession
#> 4                    use/attempted use
#> 5            evading sample collection
#> 6       non-anatlyical: administration
#> 7                          trafficking
#> 8 violation of period of ineligibility
```

Changing the `sanction_type` classification to non-analytic requires
missing (`NA_character_`) values for `substance_group`:

``` r

# Change sanction_type to non-analytic
tidy_substances <- tidy_substances |> 
  dplyr::mutate(
    sanction_type = dplyr::case_when(
      substance_group == "UNCLASSIFIED" & substance_reason == "possession" ~ "non-analytic",
      substance_group == "UNCLASSIFIED" & substance_reason == "use/attempted use" ~ "non-analytic",
      substance_group == "UNCLASSIFIED" & substance_reason == "evading sample collection" ~ "non-analytic",
      substance_group == "UNCLASSIFIED" & substance_reason == "non-anatlyical: administration" ~ "non-analytic",
      substance_group == "UNCLASSIFIED" & substance_reason == "trafficking" ~ "non-analytic",
      TRUE ~ sanction_type
    )
  ) 
# Change substance_group to NA_character_
tidy_substances <- tidy_substances |> 
  dplyr::mutate(
    substance_group = dplyr::case_when(
      sanction_type == "non-analytic" ~ NA_character_,
      TRUE ~ substance_group)
    ) 
```

Remove the empty `substance_reason` values:

``` r

tidy_substances <- dplyr::filter(tidy_substances, substance_reason != "")
```

## Tidy substances

Now all the substances have been properly classified as [Adverse
Analytical
Findings](https://www.usada.org/spirit-of-sport/education/alphabet-soup-results-management/#:~:text).

``` r

tidy_substances |> 
  dplyr::count(sanction_type, substance_group) |> 
  tidyr::pivot_wider(names_from = sanction_type, values_from = n)
#> # A tibble: 15 × 3
#>    substance_group                       analytic `non-analytic`
#>    <chr>                                    <int>          <int>
#>  1 M1 MANIPULATION OF BLOOD                     3             NA
#>  2 M2 CHEMICAL AND PHYSICAL MANIPULATION        1             NA
#>  3 P1 BETA-BLOCKERS                             2             NA
#>  4 S0 UNAPPROVED SUBSTANCES                     2             NA
#>  5 S1 ANABOLIC AGENTS                         370             NA
#>  6 S2 PEP HORMONES/G FACTORS/MIMETICS          46             NA
#>  7 S3 BETA-2 AGONISTS                          12             NA
#>  8 S4 HORMONE AND METABOLIC MODULATORS        101             NA
#>  9 S5 DIURETICS/MASKING AGENTS                 70             NA
#> 10 S6 STIMULANTS                               77             NA
#> 11 S7 NARCOTICS                                 2             NA
#> 12 S8 CANNABINOIDS                             47             NA
#> 13 S9 GLUCOCORTICOIDS                           6             NA
#> 14 UNCLASSIFIED                                10             NA
#> 15 NA                                          NA              6
```

And the `non-analytic` sanctions are truly [Non-Analytical Anti-doping
Rule
Violations](https://www.usada.org/spirit-of-sport/education/non-analytical-anti-doping-rule-violations/).

``` r

dplyr::filter(tidy_substances, sanction_type == "non-analytic") |> 
  dplyr::count(substance_reason, substance_cat) |> 
  tidyr::pivot_wider(names_from = substance_cat, values_from = n)
#> # A tibble: 6 × 3
#>   substance_reason               single multiple
#>   <chr>                           <int>    <int>
#> 1 3 whereabouts failures              1       NA
#> 2 evading sample collection          NA        1
#> 3 non-anatlyical: administration     NA        1
#> 4 possession                         NA        1
#> 5 trafficking                        NA        1
#> 6 use/attempted use                  NA        1
```
