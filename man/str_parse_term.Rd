% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parse_search_term.R
\name{str_parse_term}
\alias{str_parse_term}
\title{Parse string into individual terms (as tibble)}
\usage{
str_parse_term(term)
}
\arguments{
\item{search_term}{}
}
\value{
tibble of unique terms and term
}
\description{
Parse string into individual terms (as tibble)
}
\examples{
require(stringr)
require(purrr)
require(tibble)
str_parse_term(term = "A large size in stockings is hard to sell.")
}
