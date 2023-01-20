#=====================================================================#
# File name: _common.R
# This is code to create: common settings and utilities for dopingdata
# Authored by and feedback to: @mjfrigaard
# Last updated: 2023-01-19
# MIT License
# Version: 0.000000.9
#=====================================================================#

set.seed(1014)
# knitr settings ----
knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  # cache = TRUE,
  fig.retina = 2,
  fig.width = 6,
  fig.asp = 2/3
)
# options  ----
options(
  dplyr.print_min = 6,
  dplyr.print_max = 6,
  stringr.view_n = 10,
  crayon.enabled = TRUE,
  pillar.bold = TRUE,
  width = 60, # 80 - 3 for #> comment
  scipen = 9999
)

# import font ----
extrafont::font_import(
    paths = "assets/Ubuntu/",
    prompt = FALSE)

# add font ----
sysfonts::font_add(
    family =  "Ubuntu",
    regular = "assets/Ubuntu/Ubuntu-Regular.ttf")

# add theme ----
source("R/theme_ggp2g.R")
