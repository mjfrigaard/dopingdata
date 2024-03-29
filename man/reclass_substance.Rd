% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/reclass_substance.R
\name{reclass_substance}
\alias{reclass_substance}
\title{Re-classify a specific WADA substance}
\usage{
reclass_substance(
  df,
  substance,
  value,
  substance_col = "substance_reason",
  wb = FALSE
)
}
\arguments{
\item{df}{data from USADA website}

\item{substance}{character string of banned WADA substances}

\item{value}{character string of substance group value}

\item{substance_col}{column with substances/reasons for sanctions (assumes
it's \code{substance_reason}).}

\item{wb}{logical, include word boundary?}
}
\value{
substance dataset with newly classified substances
}
\description{
Re-classify a specific WADA substance
}
