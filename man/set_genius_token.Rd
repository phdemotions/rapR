% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geniusAPI.R
\name{set_genius_token}
\alias{set_genius_token}
\title{Set or Update the Genius API token}
\usage{
set_genius_token(token = NULL)
}
\arguments{
\item{token}{A string representing the Genius API token. If \code{NULL}, the function prompts the user to enter the token interactively.}
}
\value{
None. This function is called for its side effect of setting or updating the environment variable \code{GENIUS_API_TOKEN}.
}
\description{
This function checks if the Genius API token is already set in the environment.
If the token is set, it asks the user if they want to update it. If not set or if the user
chooses to update it, the function prompts the user to enter their Genius API token and sets it
in the environment for the current R session.
}
\examples{
\dontrun{
set_genius_token()
}
}
