#' Search for an Artist and Retrieve Their Details as a Dataframe
#'
#' This function searches for an artist on Genius using their name and retrieves detailed information about the artist.
#' If multiple artists are found, the user is prompted to choose the correct artist. The function returns the artist's details
#' in a dataframe format.
#'
#' @param artist_name A string representing the name of the artist to search for. This parameter is required.
#'
#' @return A dataframe containing details about the artist, including their ID, name, URL, header image URL, image URL,
#' verification status, and IQ score. The function will return an error if the artist is not found or if there are issues with the API request.
#' @export
#'
#' @importFrom magrittr %>%
#' @importFrom dplyr select distinct
#' @importFrom httr add_headers GET content status_code
#' @importFrom jsonlite fromJSON
#' @importFrom rlang .data
#'
#' @examples
#' \dontrun{
#' artist_df <- genius_get_artist_details_df("Kendrick Lamar")
#' print(artist_df)
#' }
genius_get_artist_details_df <- function(artist_name) {

  # Ensure the API token is set
  check_genius_token()

  # Search for the artist using the search function
  search_results <- genius_get_search_results(query = artist_name)

  # Extract the primary artist info from the search results
  hits <- search_results$response$hits

  # Extract unique primary artist information from the song results
  artist_info <- hits %>%
    dplyr::select(.data$result.primary_artist.id, .data$result.primary_artist.name, .data$result.primary_artist.url) %>%
    dplyr::distinct()

  # Check if artist was found
  if (nrow(artist_info) == 0) {
    stop("Artist not found in search results.")
  }

  # If multiple artists are found, prompt the user to choose
  if (nrow(artist_info) > 1) {
    cat("Multiple artists found. Please choose the correct one:\n")

    for (i in seq_len(nrow(artist_info))) {
      cat(i, ":", artist_info$result.primary_artist.name[i], "\n")
    }

    # Get user input for the correct artist
    choice <- as.integer(readline(prompt = "Enter the number corresponding to the correct artist: "))

    # Validate user input
    if (is.na(choice) || choice < 1 || choice > nrow(artist_info)) {
      stop("Invalid choice. Please run the function again and enter a valid number.")
    }

    # Extract the chosen artist ID
    artist_id <- artist_info$result.primary_artist.id[choice]
  } else {
    # If only one artist is found, automatically select it
    artist_id <- artist_info$result.primary_artist.id[1]
  }

  # Get detailed artist information using the /artists/:id endpoint
  base_url <- paste0("https://api.genius.com/artists/", artist_id)
  headers <- httr::add_headers(Authorization = paste("Bearer", Sys.getenv("GENIUS_API_TOKEN")))

  response <- httr::GET(url = base_url, headers)

  # Check if the request was successful
  if (httr::status_code(response) != 200) {
    stop("Request failed with status: ", httr::status_code(response), " - ", httr::content(response, "text", encoding = "UTF-8"))
  }

  # Parse the JSON content
  artist_details <- jsonlite::fromJSON(httr::content(response, "text", encoding = "UTF-8"), flatten = TRUE)

  # Extract relevant details with default values for missing fields
  artist_info_list <- list(
    id = ifelse(is.null(artist_details$response$artist$id), NA, artist_details$response$artist$id),
    name = ifelse(is.null(artist_details$response$artist$name), NA, artist_details$response$artist$name),
    url = ifelse(is.null(artist_details$response$artist$url), NA, artist_details$response$artist$url),
    header_image_url = ifelse(is.null(artist_details$response$artist$header_image_url), NA, artist_details$response$artist$header_image_url),
    image_url = ifelse(is.null(artist_details$response$artist$image_url), NA, artist_details$response$artist$image_url),
    is_verified = ifelse(is.null(artist_details$response$artist$is_verified), NA, artist_details$response$artist$is_verified),
    iq = ifelse(is.null(artist_details$response$artist$iq), NA, artist_details$response$artist$iq)
  )

  # Convert the list to a dataframe
  artist_df <- as.data.frame(artist_info_list, stringsAsFactors = FALSE)

  return(artist_df)
}
