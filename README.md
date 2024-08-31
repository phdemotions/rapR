# rapR

[![R-CMD-check](https://github.com/phdemotions/rapR/workflows/R-CMD-check/badge.svg)](https://github.com/phdemotions/rapR/actions)
[![CRAN status](https://www.r-pkg.org/badges/version/rapR)](https://CRAN.R-project.org/package=rapR)

`rapR` is an R package that provides an interface to the Genius and Spotify APIs, allowing users to retrieve annotations, referents, song details, artist details, and search results. It aims to make it easier for users to interact with these APIs directly from R.

## Installation

You can install the development version of `rapR` from [GitHub](https://github.com/phdemotions/rapR) with:

```r
# Install the remotes package if you haven't already
install.packages("remotes")

# Install the rapR package from GitHub
remotes::install_github("phdemotions/rapR")
```

## Setup
Before using the functions provided by rapR, you need to set up your Genius API token.

### Setting Your Genius API Token
1. Obtain a Genius API Token: You need to register on Genius to get an API token.
2. Set the Token in R: Use the set_genius_token() function to set the token for your current R session.

```r
library(rapR)

# Set your Genius API token
set_genius_token("your_genius_api_token_here")
```
Alternatively, you can store your token as an environment variable in your .Renviron file:
```r
Sys.setenv(GENIUS_API_TOKEN = "your_genius_api_token")
```

## Usage
Once your Genius API token is set, you can use the various functions provided by rapR to interact with the Genius API.

### Example: Get Annotation Details
```r
# Retrieve annotation details for a specific annotation ID
annotation_details <- genius_get_annotation(annotation_id = "12345")
print(annotation_details)
```

### Example: Get Song Details
```r
# Retrieve song details for a specific song ID
song_details <- genius_get_song(song_id = "67890")
print(song_details)
```

###Example: Search for Songs
```r
# Search for songs by a keyword
search_results <- genius_get_search_results(query = "What is Love")
print(search_results)

```
## Functions

### Key Functions
set_genius_token(): Set or update the Genius API token for the current session.

`genius_get_artist_details_df()`
This function searches for an artist on Genius by their name and retrieves detailed information about them. If multiple artists match the search query, the user is prompted to choose the correct one.

- Parameters:
  - artist_name: A string representing the name of the artist to search for.
- Returns:
  - A dataframe with details about the artist, including their ID, name, URL, header image URL, image URL, verification status, and IQ score.

Example:
```r
artist_df <- genius_get_artist_details_df("Kendrick Lamar")
print(artist_df)
```
`genius_get_song_details_df()`
This function searches for a song on Genius by its name and retrieves detailed information about the song. If multiple songs match the search query, the user is prompted to choose the correct one.

- Parameters:
  - song_name: A string representing the name of the song to search for.
- Returns:
  - A dataframe containing details about the song, such as its ID, title, URL, release date, song art image URL, primary artist, lyrics state, and page views.

Example:

```r
song_df <- genius_get_song_details_df("HUMBLE")
print(song_df)
```
`genius_get_all_songs_from_artist()`
This function retrieves all songs by a specific artist from the Genius API, handling pagination automatically. It fetches songs until all pages are retrieved and returns a consolidated list in a dataframe format.

- Parameters:
  - artist_id: A string representing the ID of the artist whose songs are to be retrieved.
- Returns:
  - A dataframe containing all songs by the specified artist, including various fields such as song ID, title, and other metadata.

- Example:
```r
all_songs_df <- genius_get_all_songs_from_artist("12345")
print(all_songs_df)
```

### Other Functions
rapR provides several other functions to interact with the Genius API:

genius_get_annotation(): Retrieve annotation details.
genius_get_referents(): Retrieve referents (annotations) based on filters.
genius_get_song(): Retrieve song details.
genius_get_artist(): Retrieve artist details.
genius_get_artist_songs(): Retrieve songs by a specific artist.
genius_get_web_page(): Retrieve details about a specific web page.
genius_get_search_results(): Retrieve search results based on a query.



## Contributing
Contributions to rapR are welcome! If you find a bug or have a feature request, please open an issue on [GitHub](https://github.com/phdemotions/rapR/issues).

## License
This package is licensed under the MIT License. See the LICENSE file for more details.


## Acknowledgements
- The Genius API for providing a great platform for music data.
- The httr and jsonlite packages for making API interactions easier.
