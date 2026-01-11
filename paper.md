---
title: 'rapR: An R Interface to the Genius and Spotify APIs'
tags:
  - R
  - music metadata
  - lyrics
  - API wrapper
  - Genius
  - Spotify
  - data science
authors:
  - name: Josh Gonzales
    orcid: 0000-0001-8633-3380
    affiliation: 1
affiliations:
 - name: University of Guelph, Canada
   index: 1
date: 11 January 2024
bibliography: paper.bib
---

# Summary

`rapR` is an R package that provides a comprehensive interface to the Genius and Spotify APIs, enabling researchers and data scientists to programmatically access music metadata, lyrics annotations, artist information, and song details. The package simplifies the process of retrieving and analyzing music-related data directly from R, making it accessible for computational music analysis, cultural analytics, and digital humanities research.

# Statement of Need

Music information retrieval and lyrical analysis are increasingly important in various research domains, including cultural studies, digital humanities, computational social science, and music information retrieval [@McFee2015; @Tsaptsinos2017]. While platforms like Genius provide rich crowdsourced annotations and metadata about songs and lyrics, and Spotify offers extensive music metadata, accessing this data programmatically can be challenging for researchers who primarily work in R.

Existing tools for accessing music APIs in R are limited or focused on specific platforms. For instance, while packages like `spotifyr` [@Thompson2021] provide access to Spotify's API, there has been no comprehensive R package for the Genius API, which contains valuable crowdsourced lyrical annotations and interpretations. Furthermore, researchers often need to combine data from multiple sources, requiring separate implementations for each API.

`rapR` addresses these gaps by providing:

1. **Unified Interface**: A consistent API design across both Genius and Spotify platforms, reducing the cognitive load for researchers working with multiple data sources.

2. **User-Friendly Functions**: High-level functions that abstract away the complexity of API authentication, pagination, rate limiting, and response parsing, allowing researchers to focus on their analysis rather than implementation details.

3. **Interactive Disambiguation**: When searches return multiple results, the package provides interactive prompts to help users select the correct artist or song, reducing errors in data collection.

4. **Comprehensive Coverage**: Support for multiple Genius API endpoints including annotations, referents, song details, artist information, and search functionality.

5. **Data Frame Output**: All functions return data in tidy data frames, making the results immediately compatible with the tidyverse ecosystem [@Wickham2019] and facilitating downstream analysis.

# Key Features

The package provides several categories of functionality:

**Authentication Management**: The `set_genius_token()` function simplifies the process of API authentication, storing credentials securely in environment variables.

**Artist Analysis**: Functions like `genius_get_artist_details_df()` and `genius_get_all_songs_from_artist()` enable researchers to systematically collect comprehensive information about artists and their complete discographies, with automatic handling of pagination for artists with large catalogs.

**Song Metadata Retrieval**: The `genius_get_song_details_df()` function allows users to search for songs and retrieve detailed metadata including release dates, page views, and lyrics state, useful for studying song popularity and cultural impact.

**Annotation Access**: Functions such as `genius_get_annotation()` and `genius_get_referents()` provide access to the crowdsourced lyrical interpretations and annotations that make Genius unique, enabling research on collaborative meaning-making and lyrical interpretation.

**Flexible Search**: The `genius_get_search_results()` function enables open-ended queries, supporting exploratory research and data discovery.

All functions are designed with error handling, rate limiting considerations (including random delays between requests), and clear documentation to support reproducible research workflows.

# Research Applications

`rapR` has potential applications across multiple research domains:

- **Cultural Analytics**: Studying trends in music and lyrics over time, analyzing the evolution of musical genres, or investigating cultural phenomena reflected in popular music.
- **Digital Humanities**: Examining literary devices, themes, and language use in song lyrics across different time periods or cultural contexts.
- **Music Information Retrieval**: Building datasets for machine learning models, analyzing metadata patterns, or creating comprehensive music databases.
- **Computational Social Science**: Investigating the relationship between music popularity, social trends, and cultural events.

# Acknowledgements

I acknowledge the Genius and Spotify platforms for providing public APIs that enable this research, and the httr [@Wickham2020] and jsonlite [@Ooms2014] packages that facilitate API interactions in R.

# References
