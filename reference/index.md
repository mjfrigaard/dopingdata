# Package index

## Harvesting Data

Fetch and cache the live USADA sanctions data

- [`get_sanctions_data()`](https://mjfrigaard.github.io/dopingdata/reference/get_sanctions_data.md)
  : Get USADA sanctions data
- [`get_prohibited_association()`](https://mjfrigaard.github.io/dopingdata/reference/get_prohibited_association.md)
  : Get USADA prohibited-association data
- [`update_sanctions_data()`](https://mjfrigaard.github.io/dopingdata/reference/update_sanctions_data.md)
  : Refresh the cached USADA sanctions data

## Wrangling Data

Clean and tidy the raw sanctions text, dates, and sports

- [`process_text()`](https://mjfrigaard.github.io/dopingdata/reference/process_text.md)
  : Process raw data
- [`clean_dates()`](https://mjfrigaard.github.io/dopingdata/reference/clean_dates.md)
  : Clean sanction dates
- [`clean_sports()`](https://mjfrigaard.github.io/dopingdata/reference/clean_sports.md)
  : Clean/tidy USADA sports
- [`split_cols()`](https://mjfrigaard.github.io/dopingdata/reference/split_cols.md)
  : Separate column into multiple columns
- [`add_match_col()`](https://mjfrigaard.github.io/dopingdata/reference/add_match_col.md)
  : Create column with matched value (base R)
- [`pivot_term_long()`](https://mjfrigaard.github.io/dopingdata/reference/pivot_term_long.md)
  : Parse string into individual terms

## Classifying Substances

Classify sanctions against the WADA prohibited substance list

- [`classify_wada_substances()`](https://mjfrigaard.github.io/dopingdata/reference/classify_wada_substances.md)
  : Classify banned WADA substances
- [`reclass_substance()`](https://mjfrigaard.github.io/dopingdata/reference/reclass_substance.md)
  : Re-classify a specific WADA substance
- [`make_regex()`](https://mjfrigaard.github.io/dopingdata/reference/make_regex.md)
  : Create a Regular Expression Pattern
- [`create_word_boundary()`](https://mjfrigaard.github.io/dopingdata/reference/create_word_boundary.md)
  : Create a regular expression with word boundaries

## Visualizing Substances

ggplot2 theme for package visualizations

- [`theme_ggp2g()`](https://mjfrigaard.github.io/dopingdata/reference/theme_ggp2g.md)
  : ggplot2 theme (doping data)

## Utilities

File export/import helpers and operators

- [`export_data()`](https://mjfrigaard.github.io/dopingdata/reference/export_data.md)
  : Export data object to path

- [`export_extdata()`](https://mjfrigaard.github.io/dopingdata/reference/export_extdata.md)
  :

  Export data to `inst/extdata/` or `inst/extdata/raw`

- [`get_recent()`](https://mjfrigaard.github.io/dopingdata/reference/get_recent.md)
  : Return the most recent modification date

- [`get_recent_file()`](https://mjfrigaard.github.io/dopingdata/reference/get_recent_file.md)
  : Return the most recent data file in folder

- [`clip_top_file()`](https://mjfrigaard.github.io/dopingdata/reference/clip_top_file.md)
  :

  Copy the path to top data file in `extdata/` folder on the clipboard

- [`dtstamp()`](https://mjfrigaard.github.io/dopingdata/reference/dtstamp.md)
  : Insert date/time stamp

- [`verify_inst_path()`](https://mjfrigaard.github.io/dopingdata/reference/verify_inst_path.md)
  : Verify inst/ path

- [`` `%nin%` ``](https://mjfrigaard.github.io/dopingdata/reference/nin.md)
  : Not in (not-in operator for R.)

- [`` `%otherwise%` ``](https://mjfrigaard.github.io/dopingdata/reference/otherwise.md)
  : null-coalescing operator. See purrr for details.
