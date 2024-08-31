#' Set or Update the Genius API token
#'
#' This function checks if the Genius API token is already set in the environment.
#' If the token is set, it asks the user if they want to update it. If not set or if the user
#' chooses to update it, the function prompts the user to enter their Genius API token and sets it
#' in the environment for the current R session.
#'
#' @param token A string representing the Genius API token. If \code{NULL}, the function prompts the user to enter the token interactively.
#' @return None. This function is called for its side effect of setting or updating the environment variable \code{GENIUS_API_TOKEN}.
#' @export
#'
#' @examples
#' \dontrun{
#' set_genius_token()
#' }
set_genius_token <- function(token = NULL) {
  # Check if the Genius API token is already set
  current_token <- Sys.getenv("GENIUS_API_TOKEN")

  if (current_token != "") {
    # Ask the user if they want to update the existing token
    cat("The 'GENIUS_API_TOKEN' environment variable is already set.\n")
    update <- readline(prompt = "Do you want to update it? (yes/no): ")

    if (tolower(update) != "yes") {
      message("Retaining the existing Genius API token.")
      return(invisible(NULL))
    }
  }

  # If token is not provided, prompt the user for the token
  if (is.null(token)) {
    token <- readline(prompt = "Please enter your Genius API token: ")
  }

  # Check if the token is not empty
  if (token == "") {
    stop("The Genius API token cannot be empty. Please provide a valid token.")
  }

  # Set the token in the environment for the current session
  Sys.setenv(GENIUS_API_TOKEN = token)
  message("Genius API token has been set successfully.")
}

#' Check if the Genius API token is set or prompt for it
#'
#' This internal function checks if the Genius API token is set in the environment.
#' If the token is not set, it prompts the user to enter it interactively.
#' The token is then stored in the environment for the current R session.
#'
#' @return None. Sets the environment variable \code{GENIUS_API_TOKEN} if the token is provided interactively.
#' Throws an error if the token is not set and not provided interactively.
#' @keywords internal
check_genius_token <- function() {
  access_token <- Sys.getenv("GENIUS_API_TOKEN")

  # Check if the token is not set
  if (access_token == "") {
    # Prompt the user for the token
    access_token <- readline(prompt = "The 'GENIUS_API_TOKEN' environment variable is not set. Please enter your Genius API token: ")

    # If the user provides a token, set it in the environment for the current session
    if (access_token != "") {
      Sys.setenv(GENIUS_API_TOKEN = access_token)
    } else {
      stop("Access token is missing. Please set the 'GENIUS_API_TOKEN' environment variable.")
    }
  }
}

#' Retrieve Annotation Details from Genius API
#'
#' This function retrieves the details of a specific annotation from the Genius API.
#'
#' @param annotation_id A string representing the ID of the annotation to retrieve. This parameter is required.
#' @param text_format A string specifying the format of the text returned. Options are "dom" (default), "html", or "plain".
#'
#' @return A list containing the annotation details in JSON format. The list includes various fields such as 'id', 'annotator_id', 'annotator_login', etc.
#' The function will return an error if the request fails (i.e., if the HTTP status code is not 200).
#' @export
#'
#' @examples
#' \dontrun{
#' genius_get_annotation(annotation_id = "12345")
#' }
genius_get_annotation <- function(annotation_id, text_format = "dom") {
  # Check if the Genius API token is set
  check_genius_token()

  # Get the access token from the environment
  access_token <- Sys.getenv("GENIUS_API_TOKEN")

  # Base URL for the Genius API
  base_url <- paste0("https://api.genius.com/annotations/", annotation_id)

  # Set up the authorization header
  headers <- httr::add_headers(Authorization = paste("Bearer", access_token))

  # Define query parameters
  query_params <- list(text_format = text_format)

  # Make the GET request
  response <- httr::GET(url = base_url, headers, query = query_params)

  # Check if the request was successful
  if (httr::status_code(response) != 200) {
    stop("Request failed with status: ", httr::status_code(response), " - ", httr::content(response, "text", encoding = "UTF-8"))
  }

  # Parse and return the JSON content
  content_as_json <- jsonlite::fromJSON(httr::content(response, "text", encoding = "UTF-8"), flatten = TRUE)
  return(content_as_json)
}

#' Retrieve Referents from Genius API
#'
#' This function retrieves referents (annotations) from the Genius API based on various filter criteria.
#'
#' @param created_by_id An optional integer representing the ID of the user who created the referents. Default is \code{NULL}.
#' @param song_id An optional integer representing the ID of the song to filter referents by. Default is \code{NULL}. Must not be used with \code{web_page_id}.
#' @param web_page_id An optional integer representing the ID of the web page to filter referents by. Default is \code{NULL}. Must not be used with \code{song_id}.
#' @param text_format A string specifying the format of the text returned. Options are "dom" (default), "html", or "plain".
#' @param per_page An optional integer specifying the number of results per page. Default is \code{NULL}.
#' @param page An optional integer specifying the page of results to return. Default is \code{NULL}.
#'
#' @return A list containing the referents in JSON format. The list includes various fields such as 'id', 'annotator_id', 'annotator_login', etc.
#' The function will return an error if the request fails (i.e., if the HTTP status code is not 200) or if both \code{song_id} and \code{web_page_id} are provided.
#' @export
#'
#' @examples
#' \dontrun{
#' genius_get_referents(song_id = 12345)
#' }
genius_get_referents <- function(created_by_id = NULL, song_id = NULL, web_page_id = NULL,
                                 text_format = "dom", per_page = NULL, page = NULL) {

  # Check if the Genius API token is set
  check_genius_token()

  # Get the access token from the environment
  access_token <- Sys.getenv("GENIUS_API_TOKEN")

  # Check that either song_id or web_page_id is provided, but not both
  if (!is.null(song_id) && !is.null(web_page_id)) {
    stop("You may pass only one of 'song_id' and 'web_page_id', not both.")
  }

  # Base URL for the Genius API
  base_url <- "https://api.genius.com/referents"

  # Set up the authorization header
  headers <- httr::add_headers(Authorization = paste("Bearer", access_token))

  # Define query parameters
  query_params <- list(
    created_by_id = created_by_id,
    song_id = song_id,
    web_page_id = web_page_id,
    text_format = text_format,
    per_page = per_page,
    page = page
  )

  # Remove NULL parameters
  query_params <- query_params[!sapply(query_params, is.null)]

  # Make the GET request
  response <- httr::GET(url = base_url, headers, query = query_params)

  # Check if the request was successful
  if (httr::status_code(response) != 200) {
    stop("Request failed with status: ", httr::status_code(response), " - ", httr::content(response, "text", encoding = "UTF-8"))
  }

  # Parse and return the JSON content
  content_as_json <- jsonlite::fromJSON(httr::content(response, "text", encoding = "UTF-8"), flatten = TRUE)
  return(content_as_json)
}

#' Retrieve Song Details from Genius API
#'
#' This function retrieves detailed information about a specific song from the Genius API.
#'
#' @param song_id A string representing the ID of the song to retrieve. This parameter is required.
#' @param text_format A string specifying the format of the text returned. Options are "dom" (default), "html", or "plain".
#'
#' @return A list containing the song details in JSON format. The list includes various fields such as 'id', 'title', 'primary_artist', etc.
#' The function will return an error if the request fails (i.e., if the HTTP status code is not 200) or if the \code{song_id} is not provided.
#' @export
#'
#' @examples
#' \dontrun{
#' genius_get_song(song_id = "12345")
#' }
genius_get_song <- function(song_id, text_format = "dom") {

  # Check if the Genius API token is set
  check_genius_token()

  # Get the access token from the environment
  access_token <- Sys.getenv("GENIUS_API_TOKEN")

  # Check if song_id is provided
  if (is.null(song_id) || song_id == "") {
    stop("The 'song_id' parameter must be provided.")
  }

  # Base URL for the Genius API
  base_url <- paste0("https://api.genius.com/songs/", song_id)

  # Set up the authorization header
  headers <- httr::add_headers(Authorization = paste("Bearer", access_token))

  # Define query parameters
  query_params <- list(text_format = text_format)

  # Make the GET request
  response <- httr::GET(url = base_url, headers, query = query_params)

  # Check if the request was successful
  if (httr::status_code(response) != 200) {
    stop("Request failed with status: ", httr::status_code(response), " - ", httr::content(response, "text", encoding = "UTF-8"))
  }

  # Parse and return the JSON content
  content_as_json <- jsonlite::fromJSON(httr::content(response, "text", encoding = "UTF-8"), flatten = TRUE)
  return(content_as_json)
}

#' Retrieve Artist Details from Genius API
#'
#' This function retrieves detailed information about a specific artist from the Genius API.
#'
#' @param artist_id A string representing the ID of the artist to retrieve. This parameter is required.
#' @param text_format A string specifying the format of the text returned. Options are "dom" (default), "html", or "plain".
#'
#' @return A list containing the artist details in JSON format. The list includes various fields such as 'id', 'name', 'url', etc.
#' The function will return an error if the request fails (i.e., if the HTTP status code is not 200) or if the \code{artist_id} is not provided.
#' @export
#'
#' @examples
#' \dontrun{
#' genius_get_artist(artist_id = "12345")
#' }
genius_get_artist <- function(artist_id, text_format = "dom") {

  # Check if the Genius API token is set
  check_genius_token()

  # Get the access token from the environment
  access_token <- Sys.getenv("GENIUS_API_TOKEN")

  # Check if artist_id is provided
  if (is.null(artist_id) || artist_id == "") {
    stop("The 'artist_id' parameter must be provided.")
  }

  # Base URL for the Genius API
  base_url <- paste0("https://api.genius.com/artists/", artist_id)

  # Set up the authorization header
  headers <- httr::add_headers(Authorization = paste("Bearer", access_token))

  # Define query parameters
  query_params <- list(text_format = text_format)

  # Make the GET request
  response <- httr::GET(url = base_url, headers, query = query_params)

  # Check if the request was successful
  if (httr::status_code(response) != 200) {
    stop("Request failed with status: ", httr::status_code(response), " - ", httr::content(response, "text", encoding = "UTF-8"))
  }

  # Parse and return the JSON content
  content_as_json <- jsonlite::fromJSON(httr::content(response, "text", encoding = "UTF-8"), flatten = TRUE)
  return(content_as_json)
}

#' Retrieve Songs by Artist from Genius API
#'
#' This function retrieves a list of songs by a specific artist from the Genius API, with options to sort and paginate the results.
#'
#' @param artist_id A string representing the ID of the artist whose songs are to be retrieved. This parameter is required.
#' @param sort A string specifying the sorting order of the results. Options are "title" (default), "popularity", etc.
#' @param per_page An integer specifying the number of results to return per page. Default is 20.
#' @param page An integer specifying the page number of results to return. Default is 1.
#'
#' @return A list containing the song details in JSON format. The list includes various fields such as 'id', 'title', 'primary_artist', etc.
#' The function will return an error if the request fails (i.e., if the HTTP status code is not 200) or if the \code{artist_id} is not provided.
#' @export
#'
#' @examples
#' \dontrun{
#' genius_get_artist_songs(
#'   artist_id = "12345",
#'   sort = "popularity",
#'   per_page = 10,
#'   page = 2
#' )
#' }
genius_get_artist_songs <- function(artist_id, sort = "title", per_page = 20, page = 1) {

  # Check if the Genius API token is set
  check_genius_token()

  # Get the access token from the environment
  access_token <- Sys.getenv("GENIUS_API_TOKEN")

  # Check if artist_id is provided
  if (is.null(artist_id) || artist_id == "") {
    stop("The 'artist_id' parameter must be provided.")
  }

  # Base URL for the Genius API
  base_url <- paste0("https://api.genius.com/artists/", artist_id, "/songs")

  # Set up the authorization header
  headers <- httr::add_headers(Authorization = paste("Bearer", access_token))

  # Define query parameters
  query_params <- list(
    sort = sort,
    per_page = per_page,
    page = page
  )

  # Make the GET request
  response <- httr::GET(url = base_url, headers, query = query_params)

  # Check if the request was successful
  if (httr::status_code(response) != 200) {
    stop("Request failed with status: ", httr::status_code(response), " - ", httr::content(response, "text", encoding = "UTF-8"))
  }

  # Parse and return the JSON content
  content_as_json <- jsonlite::fromJSON(httr::content(response, "text", encoding = "UTF-8"), flatten = TRUE)
  return(content_as_json)
}

#' Retrieve Web Page Details from Genius API
#'
#' This function retrieves details about a specific web page from the Genius API based on a provided URL.
#'
#' @param raw_annotatable_url An optional string representing the raw annotatable URL of the web page to retrieve. Default is \code{NULL}.
#' @param canonical_url An optional string representing the canonical URL of the web page to retrieve. Default is \code{NULL}.
#' @param og_url An optional string representing the Open Graph URL of the web page to retrieve. Default is \code{NULL}.
#'
#' @return A list containing the web page details in JSON format. The list includes various fields such as 'id', 'url', 'title', etc.
#' The function will return an error if the request fails (i.e., if the HTTP status code is not 200) or if none of the URL parameters are provided.
#' @export
#'
#' @examples
#' \dontrun{
#' genius_get_web_page(
#'   raw_annotatable_url = "https://genius.com/Some-annotatable-page"
#' )
#' }
genius_get_web_page <- function(raw_annotatable_url = NULL, canonical_url = NULL, og_url = NULL) {

  # Check if the Genius API token is set
  check_genius_token()

  # Get the access token from the environment
  access_token <- Sys.getenv("GENIUS_API_TOKEN")

  # Ensure at least one URL parameter is provided
  if (is.null(raw_annotatable_url) && is.null(canonical_url) && is.null(og_url)) {
    stop("At least one URL parameter ('raw_annotatable_url', 'canonical_url', or 'og_url') must be provided.")
  }

  # Base URL for the Genius API
  base_url <- "https://api.genius.com/web_pages/lookup"

  # Set up the authorization header
  headers <- httr::add_headers(Authorization = paste("Bearer", access_token))

  # Define query parameters
  query_params <- list(
    raw_annotatable_url = raw_annotatable_url,
    canonical_url = canonical_url,
    og_url = og_url
  )

  # Remove NULL parameters
  query_params <- query_params[!sapply(query_params, is.null)]

  # Make the GET request
  response <- httr::GET(url = base_url, headers, query = query_params)

  # Check if the request was successful
  if (httr::status_code(response) != 200) {
    stop("Request failed with status: ", httr::status_code(response), " - ", httr::content(response, "text", encoding = "UTF-8"))
  }

  # Parse and return the JSON content
  content_as_json <- jsonlite::fromJSON(httr::content(response, "text", encoding = "UTF-8"), flatten = TRUE)
  return(content_as_json)
}

#' Retrieve Search Results from Genius API
#'
#' This function retrieves search results from the Genius API based on a provided search query.
#'
#' @param query A string representing the search query. This parameter is required.
#'
#' @return A list containing the search results in JSON format. The list includes various fields such as 'hits', 'title', 'primary_artist', etc.
#' The function will return an error if the request fails (i.e., if the HTTP status code is not 200) or if the \code{query} parameter is not provided.
#' @export
#'
#' @examples
#' \dontrun{
#' genius_get_search_results(query = "Kendrick Lamar")
#' }
genius_get_search_results <- function(query) {

  # Check if the Genius API token is set
  check_genius_token()

  # Get the access token from the environment
  access_token <- Sys.getenv("GENIUS_API_TOKEN")

  # Ensure the search query is provided
  if (is.null(query) || query == "") {
    stop("The 'query' parameter must be provided.")
  }

  # Base URL for the Genius API
  base_url <- "https://api.genius.com/search"

  # Set up the authorization header
  headers <- httr::add_headers(Authorization = paste("Bearer", access_token))

  # Define query parameters
  query_params <- list(q = query)

  # Make the GET request
  response <- httr::GET(url = base_url, headers, query = query_params)

  # Check if the request was successful
  if (httr::status_code(response) != 200) {
    stop("Request failed with status: ", httr::status_code(response), " - ", httr::content(response, "text", encoding = "UTF-8"))
  }

  # Parse and return the JSON content
  content_as_json <- jsonlite::fromJSON(httr::content(response, "text", encoding = "UTF-8"), flatten = TRUE)
  return(content_as_json)
}
