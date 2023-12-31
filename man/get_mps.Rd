% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_mps.R
\name{get_mps}
\alias{get_mps}
\title{Get members of parliament}
\usage{
get_mps(term = c("current"), type = c("serving"), detail = FALSE)
}
\arguments{
\item{term}{A character vector with either "13", "14, "15" or "current"}

\item{type}{A character vector with either "all" or "current". Indicates whether we want only the current Mps of a legislature or all of them.}

\item{detail}{A boolean operator indicating whether to add additional data. Can take a few minutes in that case.}
}
\value{
A tibble.
}
\description{
Get members of parliament
}
\examples{
get_mps(c("13", "14"), "all")
}
