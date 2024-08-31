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

#' Search for a Song and Retrieve Its Details as a Dataframe
#'
#' This function searches for a song on Genius using its name and retrieves detailed information about the song.
#' If multiple songs are found, the user is prompted to choose the correct song. The function returns the song's details
#' in a dataframe format.
#'
#' @param song_name A string representing the name of the song to search for. This parameter is required.
#'
#' @return A dataframe containing details about the song, including its ID, title, URL, release date, song art image URL,
#' primary artist, lyrics state, and page views. The function will return an error if the song is not found or if there are issues with the API request.
#' @export
#'
#' @importFrom magrittr %>%
#' @importFrom dplyr select distinct
#' @importFrom httr add_headers GET content status_code
#' @importFrom jsonlite fromJSON
#'
#' @examples
#' \dontrun{
#' song_df <- genius_get_song_details_df("HUMBLE")
#' print(song_df)
#' }
genius_get_song_details_df <- function(song_name) {

  # Ensure the API token is set
  check_genius_token()

  # Search for the song using the search function
  search_results <- genius_get_search_results(query = song_name)

  # Extract the song info from the search results
  hits <- search_results$response$hits

  # Extract unique song information from the results
  song_info <- hits %>%
    dplyr::select(.data$result.id, .data$result.title, .data$result.url, .data$result.primary_artist.name) %>%
    dplyr::distinct()

  # Check if song was found
  if (nrow(song_info) == 0) {
    stop("Song not found in search results.")
  }

  # If multiple songs are found, prompt the user to choose
  if (nrow(song_info) > 1) {
    cat("Multiple songs found. Please choose the correct one:\n")

    for (i in seq_len(nrow(song_info))) {
      cat(i, ":", song_info$result.title[i], "by", song_info$result.primary_artist.name[i], "\n")
    }

    # Get user input for the correct song
    choice <- as.integer(readline(prompt = "Enter the number corresponding to the correct song: "))

    # Validate user input
    if (is.na(choice) || choice < 1 || choice > nrow(song_info)) {
      stop("Invalid choice. Please run the function again and enter a valid number.")
    }

    # Extract the chosen song ID
    song_id <- song_info$result.id[choice]
  } else {
    # If only one song is found, automatically select it
    song_id <- song_info$result.id[1]
  }

  # Get detailed song information using the /songs/:id endpoint
  base_url <- paste0("https://api.genius.com/songs/", song_id)
  headers <- httr::add_headers(Authorization = paste("Bearer", Sys.getenv("GENIUS_API_TOKEN")))

  response <- httr::GET(url = base_url, headers)

  # Check if the request was successful
  if (httr::status_code(response) != 200) {
    stop("Request failed with status: ", httr::status_code(response), " - ", httr::content(response, "text", encoding = "UTF-8"))
  }

  # Parse the JSON content
  song_details <- jsonlite::fromJSON(httr::content(response, "text", encoding = "UTF-8"), flatten = TRUE)

  # Extract relevant details with default values for missing fields
  song_info_list <- list(
    id = ifelse(is.null(song_details$response$song$id), NA, song_details$response$song$id),
    title = ifelse(is.null(song_details$response$song$title), NA, song_details$response$song$title),
    url = ifelse(is.null(song_details$response$song$url), NA, song_details$response$song$url),
    release_date = ifelse(is.null(song_details$response$song$release_date), NA, song_details$response$song$release_date),
    song_art_image_url = ifelse(is.null(song_details$response$song$song_art_image_url), NA, song_details$response$song$song_art_image_url),
    primary_artist = ifelse(is.null(song_details$response$song$primary_artist$name), NA, song_details$response$song$primary_artist$name),
    lyrics_state = ifelse(is.null(song_details$response$song$lyrics_state), NA, song_details$response$song$lyrics_state),
    page_views = ifelse(is.null(song_details$response$song$stats$pageviews), NA, song_details$response$song$stats$pageviews)
  )

  # Convert the list to a dataframe
  song_df <- as.data.frame(song_info_list, stringsAsFactors = FALSE)

  return(song_df)
}
#' Retrieve All Songs by an Artist from Genius API
#'
#' This function retrieves a list of all songs by a specific artist from the Genius API, handling pagination automatically.
#' The function continues fetching songs until all pages are retrieved and returns the consolidated list in a dataframe format.
#'
#' @param artist_id A string representing the ID of the artist whose songs are to be retrieved. This parameter is required.
#'
#' @return A dataframe containing all songs by the specified artist. The dataframe includes various fields such as song ID, title, and other metadata.
#' The function will return an error if the request fails (i.e., if the HTTP status code is not 200) or if the \code{artist_id} is not provided.
#' @export
#'
#' @importFrom dplyr bind_rows
#' @importFrom httr GET content status_code
#' @importFrom jsonlite fromJSON
#' @importFrom stats runif
#'
#' @examples
#' \dontrun{
#' all_songs_df <- genius_get_all_songs_from_artist("12345")
#' print(all_songs_df)
#' }
genius_get_all_songs_from_artist <- function(artist_id) {

  # Ensure the API token is set
  check_genius_token()

  # Initialize an empty dataframe to store songs
  all_songs_df <- data.frame()

  # Initialize pagination variables
  page <- 1
  per_page <- 20

  repeat {
    # Fetch songs for the current page
    response <- genius_get_artist_songs(
      artist_id = artist_id,
      per_page = per_page,
      page = page
    )

    # Extract the songs from the response and convert them to a dataframe
    songs <- response$response$songs
    songs_df <- as.data.frame(songs)

    # Bind the newly retrieved songs to the all_songs_df dataframe
    all_songs_df <- dplyr::bind_rows(all_songs_df, songs_df)

    # Check if we've retrieved all songs by looking at the next_page field
    next_page <- response$response$next_page

    # If there's no next page, we've retrieved all songs
    if (is.null(next_page)) {
      break
    }

    # Increment the page number for the next request
    page <- next_page

    # Introduce a random delay between 1 to 3 seconds to avoid getting flagged
    Sys.sleep(runif(1, min = 1, max = 3))
  }

  # Return the consolidated dataframe of all songs
  return(all_songs_df)
}
#' Search for a Song and Retrieve Its Details as a Dataframe
#'
#' This function searches for a song on Genius using its name and retrieves detailed information about the song.
#' If multiple songs are found, the user is prompted to choose the correct song. The function returns the song's details
#' in a dataframe format.
#'
#' @param song_name A string representing the name of the song to search for. This parameter is required.
#'
#' @return A dataframe containing details about the song, including its ID, title, URL, release date, song art image URL,
#' primary artist, lyrics state, and page views. The function will return an error if the song is not found or if there are issues with the API request.
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
#' song_df <- genius_get_song_details_df("HUMBLE")
#' print(song_df)
#' }
genius_get_song_details_df <- function(song_name) {

  # Ensure the API token is set
  check_genius_token()

  # Search for the song using the search function
  search_results <- genius_get_search_results(query = song_name)

  # Extract the song info from the search results
  hits <- search_results$response$hits

  # Extract unique song information from the results
  song_info <- hits %>%
    dplyr::select(.data$result.id, .data$result.title, .data$result.url, .data$result.primary_artist.name) %>%
    dplyr::distinct()

  # Check if song was found
  if (nrow(song_info) == 0) {
    stop("Song not found in search results.")
  }

  # If multiple songs are found, prompt the user to choose
  if (nrow(song_info) > 1) {
    cat("Multiple songs found. Please choose the correct one:\n")

    for (i in seq_len(nrow(song_info))) {
      cat(i, ":", song_info$result.title[i], "by", song_info$result.primary_artist.name[i], "\n")
    }

    # Get user input for the correct song
    choice <- as.integer(readline(prompt = "Enter the number corresponding to the correct song: "))

    # Validate user input
    if (is.na(choice) || choice < 1 || choice > nrow(song_info)) {
      stop("Invalid choice. Please run the function again and enter a valid number.")
    }

    # Extract the chosen song ID
    song_id <- song_info$result.id[choice]
  } else {
    # If only one song is found, automatically select it
    song_id <- song_info$result.id[1]
  }

  # Get detailed song information using the /songs/:id endpoint
  base_url <- paste0("https://api.genius.com/songs/", song_id)
  headers <- httr::add_headers(Authorization = paste("Bearer", Sys.getenv("GENIUS_API_TOKEN")))

  response <- httr::GET(url = base_url, headers)

  # Check if the request was successful
  if (httr::status_code(response) != 200) {
    stop("Request failed with status: ", httr::status_code(response), " - ", httr::content(response, "text", encoding = "UTF-8"))
  }

  # Parse the JSON content
  song_details <- jsonlite::fromJSON(httr::content(response, "text", encoding = "UTF-8"), flatten = TRUE)

  # Extract relevant details with default values for missing fields
  song_info_list <- list(
    id = ifelse(is.null(song_details$response$song$id), NA, song_details$response$song$id),
    title = ifelse(is.null(song_details$response$song$title), NA, song_details$response$song$title),
    url = ifelse(is.null(song_details$response$song$url), NA, song_details$response$song$url),
    release_date = ifelse(is.null(song_details$response$song$release_date), NA, song_details$response$song$release_date),
    song_art_image_url = ifelse(is.null(song_details$response$song$song_art_image_url), NA, song_details$response$song$song_art_image_url),
    primary_artist = ifelse(is.null(song_details$response$song$primary_artist$name), NA, song_details$response$song$primary_artist$name),
    lyrics_state = ifelse(is.null(song_details$response$song$lyrics_state), NA, song_details$response$song$lyrics_state),
    page_views = ifelse(is.null(song_details$response$song$stats$pageviews), NA, song_details$response$song$stats$pageviews)
  )

  # Convert the list to a dataframe
  song_df <- as.data.frame(song_info_list, stringsAsFactors = FALSE)

  return(song_df)
}
