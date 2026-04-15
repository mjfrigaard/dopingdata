# Re-classify a specific WADA substance

Re-classify a specific WADA substance

## Usage

``` r
reclass_substance(
  df,
  substance,
  value,
  substance_col = "substance_reason",
  wb = FALSE
)
```

## Arguments

- df:

  data from USADA website

- substance:

  character string of banned WADA substances

- value:

  character string of substance group value

- substance_col:

  column with substances/reasons for sanctions (assumes it's
  `substance_reason`).

- wb:

  logical, include word boundary?

## Value

substance dataset with newly classified substances
