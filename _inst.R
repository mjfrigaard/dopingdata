#=====================================================================#
# File name: _inst.R
# This is code to create: packages for dopingdata
# Authored by and feedback to: @mjfrigaard
# Last updated: 2023-01-19
# MIT License
# Version: 0.000000.9
#=====================================================================#

pkgs <- c("anytime", "attachment", "baseballDBR", "broom", "bs4Dash",
"cli", "config", "data.table", "datapasta", "devtools", "dplyr",
"extrafont", "feather", "forcats", "fs", "ggplot2", "ggthemes",
"golem", "gridExtra", "gt", "haven", "hms", "hrbrthemes", "htmltools",
"httpuv", "httr", "inspectdf", "janitor", "jsonlite", "kableExtra",
"knitr", "Lahman", "lubridate", "magrittr", "markdown", "methods",
"modelr", "nycflights13", "openxlsx", "palmerpenguins", "pkgdown",
"polite", "purrr", "reactable", "readr", "readxl", "remotes",
"rhub", "rlang", "rmarkdown", "rmdformats", "robotstxt", "rsconnect",
"rstudioapi", "rvest", "scales", "shiny", "shinydashboard", "shinythemes",
"showtext", "showtextdb", "snakecase", "spelling", "stringr",
"styler", "testthat", "tibble", "tidyr", "tidytext", "usethis",
"vroom", "wesanderson", "xml2")

# dput(sort(unique(pkgs)))
# install
install.packages(pkgs = pkgs)
remotes::install_github("csgillespie/roxygen2Comment", force = TRUE)
# usethis install
# purrr::map(.x = pkgs, usethis::use_package)
# renv install
renv::install(pkgs)
# snapshot
renv::snapshot(prompt = FALSE, force = TRUE)
# renv update
# renv::update(packages = pkgs)
