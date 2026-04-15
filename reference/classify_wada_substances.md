# Classify banned WADA substances

usada_data should be the table of sanctions from the [United States
Anti-Doping Agency](https://www.usada.org/news/sanctions). The
`substance_reason` column contains the justification for each sanction.
In some cases, there are multiple substances/reasons, and these should
be identified first.

## Usage

``` r
classify_wada_substances(usada_data, subs_column)
```

## Arguments

- usada_data:

  scraped data from USADA website

- subs_column:

  column with substances/reasons for sanctions

## Value

substances dataset with newly classified substances

## Examples

``` r
example_sanction_type
#>           sport                                           substance_reason
#> 1      swimming                     non-analytical: 3 whereabouts failures
#> 2 track & field                                               cannabinoids
#> 3     triathlon                  androgenic anabolic steroid; cannabinoids
#> 4 track & field non-analytical: tampering, administration, and trafficking
substances <- classify_wada_substances(
  usada_data = example_sanction_type,
  subs_column = "substance_reason"
)
head(substances[c('substance_group', 'substance_reason')])
#>                         substance_group
#> 1                          UNCLASSIFIED
#> 2                       S8 CANNABINOIDS
#> 3                    S1 ANABOLIC AGENTS
#> 4 M2 CHEMICAL AND PHYSICAL MANIPULATION
#>                                             substance_reason
#> 1                     non-analytical: 3 whereabouts failures
#> 2                                               cannabinoids
#> 3                  androgenic anabolic steroid; cannabinoids
#> 4 non-analytical: tampering, administration, and trafficking
```
