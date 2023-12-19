#=====================================================================#
# File name: _inst.R
# This is code to create: packages for dopingdata
# Authored by and feedback to: @mjfrigaard
# Last updated: 2023-01-19
# MIT License
# Version: 0.000000.9
#=====================================================================#

pkgs <- sort(unique(c("anytime", "attachment", "baseballDBR", "broom", "bs4Dash",
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
"vroom", "wesanderson", "xml2")))
pak::pkg_install(pkgs)

pak::pkg_install("csgillespie/roxygen2Comment")
pak::pkg_install('yonicd/covrpage')
