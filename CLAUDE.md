# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working
with code in this repository.

## Package Overview

`dopingdata` is an R data package providing datasets and utilities for
scraping, cleaning, classifying, and visualizing data from the United
States Anti-Doping Agency (USADA) and World Anti-Doping Agency (WADA).
It is in active development (`0.0.0.9000`).

## Development Commands

All development uses the standard devtools workflow in R:

``` r

devtools::load_all()    # Load package during development
devtools::document()    # Regenerate roxygen2 docs (man/, NAMESPACE)
devtools::check()       # Run R CMD check (full build + test + lint)
devtools::test()        # Run test suite only
pkgdown::build_site()   # Build the documentation website
```

Run a single test file:

``` r

testthat::test_file("tests/testthat/test-<name>.R")
```

Run spell check:

``` r

spelling::spell_check_package()
```

The CI pipeline (`.github/workflows/pkgdown.yaml`) only builds and
deploys the pkgdown site; it does not run `R CMD check` on push.

## Architecture

### R/ — Core function modules

Functions are organized by workflow stage:

| File(s) | Purpose |
|----|----|
| `polite-scrape.R` | Web scraping infrastructure — memoised [`polite_read_html()`](https://mjfrigaard.github.io/dopingdata/reference/polite_read_html.md), [`polite_download_file()`](https://mjfrigaard.github.io/dopingdata/reference/polite_download_file.md), [`scrape_sanctions()`](https://mjfrigaard.github.io/dopingdata/reference/scrape_sanctions.md), robots.txt compliance via [`check_rtxt()`](https://mjfrigaard.github.io/dopingdata/reference/check_rtxt.md) |
| `process_text.R`, `clean_dates.R`, `clean_sports.R`, `split_cols.R`, `add_match_col.R` | Data cleaning utilities for USADA sanction text, date standardization, multi-valued sports columns |
| `classify_wada_substances.R`, `reclass_substance.R` | Classify doping substances against WADA prohibited list categories (S1–S9, M1–M3, P1) using regex pattern matching |
| `make_regex.R`, `create_word_boundary.R` | Build regex patterns from substance name lists stored in `data/` |
| `theme_ggp2g.R` | Custom ggplot2 theme for package visualizations |
| `utils.R`, `get_recent_file.R`, `export_data.R` | Miscellaneous helpers: `%nin%`, `%otherwise%`, [`dtstamp()`](https://mjfrigaard.github.io/dopingdata/reference/dtstamp.md), file utilities |

### data/ — Pre-built datasets

51 `.rda` objects, primarily: - WADA prohibited substance lists by
category (used as lookup tables for
[`classify_wada_substances()`](https://mjfrigaard.github.io/dopingdata/reference/classify_wada_substances.md)) -
Example USADA sanction datasets at various processing stages

### data-raw/ — Raw data scripts

Scripts that produce the objects in `data/`. Not included in the built
package (listed in `.Rbuildignore`).

### tests/testthat/

Edition 3 testthat suite. Includes: - `helper-*.R` files loaded before
tests - `fixtures/` for test data - `_snaps/` for snapshot tests

### Vignette articles

Rmd articles live in the repo root (not `vignettes/`) and are built into
`docs/articles/` via pkgdown. They document the end-to-end workflow:
scraping → date/sports cleaning → substance classification →
visualization.

## Key Design Patterns

- **Memoisation**:
  [`polite_read_html()`](https://mjfrigaard.github.io/dopingdata/reference/polite_read_html.md)
  and
  [`polite_fetch_rtxt()`](https://mjfrigaard.github.io/dopingdata/reference/polite_fetch_rtxt.md)
  use `memoise` to cache HTTP responses within a session — do not expect
  repeated calls to re-fetch from the network.
- **Polite scraping**: All HTTP functions go through the `polite`
  package, which checks `robots.txt` and applies rate limiting.
  [`scrape_sanctions()`](https://mjfrigaard.github.io/dopingdata/reference/scrape_sanctions.md)
  is the primary entry point for USADA data.
- **Regex-driven classification**:
  [`classify_wada_substances()`](https://mjfrigaard.github.io/dopingdata/reference/classify_wada_substances.md)
  builds patterns from the substance list datasets via
  [`make_regex()`](https://mjfrigaard.github.io/dopingdata/reference/make_regex.md)
  /
  [`create_word_boundary()`](https://mjfrigaard.github.io/dopingdata/reference/create_word_boundary.md),
  then matches against sanction text. Substance lists in `data/` are the
  source of truth.
- **Roxygen2 workflow**: All documentation is in-source. After editing
  `.R` files, run `devtools::document()` before checking; do not
  hand-edit files in `man/` or `NAMESPACE`.
