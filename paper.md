---
title: 'rapR: An Accessible R Interface to the Genius and Spotify APIs for Music Research'
tags:
  - R
  - music metadata
  - lyrics
  - API wrapper
  - Genius
  - Spotify
  - data science
  - digital humanities
  - music psychology
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

`rapR` is an R package designed to make music data collection accessible to researchers without programming expertise. It provides a user-friendly interface to the Genius and Spotify APIs, enabling music psychology researchers, digital humanities scholars, and cultural studies investigators to programmatically collect song metadata, artist information, lyric annotations, and popularity metrics. The package emphasizes ease of use through clear function names, comprehensive documentation, interactive disambiguation, and tidy data outputs that integrate seamlessly with common analysis workflows and export easily to Excel, SPSS, or CSV formats.

# Statement of Need

Music information retrieval and lyrical analysis are increasingly important in various research domains, including cultural studies, digital humanities, computational social science, music psychology, and music information retrieval [@McFee2015; @Tsaptsinos2017]. While platforms like Genius provide rich crowdsourced annotations and metadata about songs and lyrics, and Spotify offers extensive music metadata, accessing this data programmatically presents significant barriers for researchers whose primary expertise lies in their domain rather than in software development.

The challenge is particularly acute for music psychology and cultural studies researchers who wish to conduct computational analyses but lack formal programming training. Existing tools for accessing music APIs in R often assume programming proficiency, use technical jargon, or lack comprehensive documentation for novice users. For instance, while packages like `spotifyr` [@Thompson2021] provide access to Spotify's API, there has been no R package for the Genius API that prioritizes accessibility for non-programmers. Furthermore, the Genius platform's unique crowdsourced annotations offer valuable insights into cultural interpretation and lyrical meaning-making that remain largely inaccessible to researchers without coding skills.

`rapR` addresses these critical gaps by providing:

## Accessibility-First Design

**1. Intuitive Function Names**: All functions use clear, descriptive names that reflect their purpose (e.g., `genius_get_artist_details_df()` clearly indicates it gets artist details and returns a data frame), eliminating the need to memorize technical API terminology.

**2. Interactive User Experience**: When searches return multiple results, the package provides numbered options and interactive prompts, allowing researchers to select the correct artist or song through simple text input rather than requiring additional code.

```r
# Example: When multiple artists match
artist <- genius_get_artist_details_df("Smith")
# Output: Multiple artists found. Please choose:
# 1: Will Smith
# 2: Sam Smith
# 3: Elliott Smith
# Enter the number: [user types 2]
```

**3. Comprehensive Beginner Documentation**: A detailed vignette (`getting-started`) provides step-by-step tutorials for researchers with no coding experience, including:
   - How to obtain API credentials with screenshots and detailed instructions
   - Copy-paste code examples for common research scenarios
   - Instructions for exporting data to Excel, CSV, or other formats familiar to non-R users
   - Troubleshooting guidance for common errors
   - Complete research workflow examples from data collection to export

**4. Tidy Data Output**: All functions return data in tidy data frames [@Wickham2019], making results immediately compatible with the tidyverse ecosystem and easily exportable to Excel or SPSS without requiring data transformation skills.

**5. Automatic Complexity Handling**: The package automatically manages technical aspects like pagination, rate limiting, error handling, and JSON parsing, allowing researchers to focus on their research questions rather than implementation details.

## Comprehensive Coverage

The package provides access to multiple Genius API endpoints:

- **Artist Information**: `genius_get_artist_details_df()` retrieves verified artist information including IQ scores (community contribution metrics) and all metadata
- **Song Details**: `genius_get_song_details_df()` collects song metadata including release dates, page views (popularity metrics), and lyrics completeness
- **Complete Discographies**: `genius_get_all_songs_from_artist()` automatically handles pagination to retrieve an artist's entire catalog
- **Lyric Annotations**: `genius_get_referents()` and `genius_get_annotation()` access crowdsourced lyrical interpretations, enabling research on collaborative meaning-making and cultural engagement
- **Search Functionality**: `genius_get_search_results()` enables exploratory research and flexible data discovery

## Research-Focused Features

**Error Messages for Non-Programmers**: Error messages are written in plain language, explaining what went wrong and how to fix it:

```r
# Technical error: "HTTP 401 Unauthorized"
# rapR error: "Your API token is incorrect or expired.
#             Get a new one at https://genius.com/api-clients"
```

**Rate Limiting Protection**: Functions automatically include delays between requests (with random intervals) to prevent rate limiting, eliminating a common source of frustration for novice API users.

**Flexible Data Export**: Clear documentation on exporting to multiple formats ensures researchers can analyze data in their preferred tools:

```r
# Export to Excel
library(writexl)
write_xlsx(artist_data, "my_research_data.xlsx")

# Export to CSV for SPSS
write.csv(artist_data, "my_research_data.csv", row.names = FALSE)
```

# Research Applications

`rapR` enables research across multiple domains:

**Music Psychology**: Researchers can study emotional themes in lyrics, track how artists' musical narratives evolve over their careers, or investigate the relationship between song characteristics and audience engagement (measured through page views and annotation counts).

**Cultural Studies**: The package facilitates examining language use and cultural references across genres, studying which social issues are reflected in popular music, or analyzing how the diversity of voices in music has changed over time.

**Digital Humanities**: Scholars can build comprehensive lyric corpora for computational text analysis, study patterns in crowdsourced interpretation (annotations), or investigate the relationship between critical and popular reception.

**Music Information Retrieval**: Researchers can create large-scale datasets for machine learning, analyze metadata patterns across thousands of songs, or combine Genius and Spotify data for multi-platform analysis.

## Example Research Workflow

A complete beginner-friendly workflow for studying artist evolution:

```r
library(rapR)
library(writexl)

# 1. Set API token (one-time setup)
set_genius_token("YOUR_TOKEN_HERE")

# 2. Get artist information
artist <- genius_get_artist_details_df("Kendrick Lamar")

# 3. Get complete discography (automatic pagination)
all_songs <- genius_get_all_songs_from_artist(artist$id)

# 4. Export to Excel for analysis
write_xlsx(all_songs, "kendrick_lamar_discography.xlsx")

# Result: Excel file ready for analysis in any tool
```

This workflow requires no prior programming knowledge - researchers can copy and adapt these examples for their specific needs.

# Comparison with Existing Tools

While `spotifyr` [@Thompson2021] provides R access to Spotify's API, it focuses primarily on audio features and does not access lyrical annotations or crowdsourced cultural interpretations available through Genius. No existing R package provides accessible Genius API functionality for non-technical users. Python libraries like `lyricsgenius` exist but require Python proficiency, creating barriers for researchers whose workflows are centered in R or who lack programming experience entirely.

`rapR` is the first R package to:

1. Provide comprehensive Genius API access
2. Prioritize accessibility for non-programmers through design, documentation, and user experience
3. Include extensive beginner-oriented documentation with complete research workflows
4. Offer interactive disambiguation for search results
5. Return consistently structured tidy data frames for seamless integration with research workflows

# Impact and Accessibility

By removing technical barriers to music data collection, `rapR` democratizes computational music research. Graduate students in music psychology, cultural studies researchers, and digital humanities scholars can now conduct large-scale empirical studies without requiring programming courses or computer science collaboration. The comprehensive vignette and clear documentation serve as both a tool and a teaching resource, potentially introducing researchers to computational methods who might otherwise avoid them due to technical complexity.

# Acknowledgements

I acknowledge the Genius and Spotify platforms for providing public APIs that enable this research. This package builds on the excellent work of the R community, particularly the `httr` [@Wickham2020], `jsonlite` [@Ooms2014], and `dplyr` [@Wickham2019] packages that facilitate API interactions and data manipulation in R.

# References
