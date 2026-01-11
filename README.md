# rapR: Music Data for Researchers (No Coding Experience Required!)

<!-- badges: start -->
[![R-CMD-check](https://github.com/phdemotions/rapR/workflows/R-CMD-check/badge.svg)](https://github.com/phdemotions/rapR/actions)
[![CRAN status](https://www.r-pkg.org/badges/version/rapR)](https://CRAN.R-project.org/package=rapR)
<!-- badges: end -->

## 📖 For Music Psychology & Cultural Studies Researchers

**rapR** makes it easy to collect music data for your research - even if you've never coded before. Get song information, artist details, lyrics annotations, and popularity metrics from Genius in minutes.

### Who is this for?

- 🎓 Graduate students studying music psychology
- 🔬 Researchers in cultural studies, sociology, or digital humanities
- 📊 Anyone who wants to analyze music trends without learning complex programming

### What can you research?

- **Lyrical content analysis**: Study themes, language, and cultural references in music
- **Artist evolution**: Track how artists' styles and themes change over time
- **Cultural impact**: Measure song popularity and community engagement
- **Genre comparisons**: Compare lyrical patterns across different music genres
- **Temporal trends**: Analyze how music has changed over decades

## 🚀 Quick Start (5 Minutes to Your First Data!)

### Step 1: Install rapR

```r
# Copy and paste these two lines into R:
install.packages("remotes")
remotes::install_github("phdemotions/rapR")
```

### Step 2: Get Your Free API Token

1. Go to https://genius.com/api-clients and sign in
2. Click "New API Client"
3. Enter any app name (like "My Research")
4. Enter any website URL (like "http://example.com")
5. Click "Generate Access Token"
6. Copy the token (long string of letters/numbers)

### Step 3: Start Collecting Data!

```r
library(rapR)

# Set your token (paste the token you copied in Step 2)
set_genius_token("YOUR_TOKEN_HERE")

# Get information about an artist
kendrick <- genius_get_artist_details_df("Kendrick Lamar")
print(kendrick)

# Get information about a song
song <- genius_get_song_details_df("HUMBLE")
print(song)

# Save to Excel for further analysis
library(writexl)
write_xlsx(song, "my_first_music_data.xlsx")
```

**That's it!** You've just collected music data. Open the Excel file to see what you got.

## 📚 Complete Beginner's Guide

**New to R?** Don't worry! We have a complete step-by-step tutorial:

```r
# After installing rapR, view the tutorial:
vignette("getting-started", package = "rapR")
```

This tutorial includes:
- Setting up R and rapR
- Understanding what data you can collect
- Complete research workflow examples
- How to export data to Excel/SPSS
- Troubleshooting common issues

## 💡 Real Research Examples

### Example 1: Collect All Songs by an Artist

Perfect for studying artist evolution or building a dataset:

```r
library(rapR)

# Get artist info
drake <- genius_get_artist_details_df("Drake")

# Get ALL songs by Drake
all_songs <- genius_get_all_songs_from_artist(drake$id)

# Save to Excel
library(writexl)
write_xlsx(all_songs, "drake_discography.xlsx")

# Now you have Excel data ready for analysis!
```

### Example 2: Compare Multiple Artists

Great for comparative studies:

```r
library(rapR)
library(dplyr)

# Get data for three artists
artist1 <- genius_get_artist_details_df("Kendrick Lamar")
artist2 <- genius_get_artist_details_df("J. Cole")
artist3 <- genius_get_artist_details_df("Drake")

# Combine into one dataset
comparison <- bind_rows(
  artist1 %>% mutate(searched_artist = "Kendrick Lamar"),
  artist2 %>% mutate(searched_artist = "J. Cole"),
  artist3 %>% mutate(searched_artist = "Drake")
)

# Save for analysis
write_xlsx(comparison, "artist_comparison.xlsx")
```

### Example 3: Study Cultural Impact Through Annotations

Genius users annotate (explain) lyrics. More annotations = more cultural engagement:

```r
library(rapR)

# Get song details
song <- genius_get_song_details_df("Alright")

# Get all the community annotations for this song
annotations <- genius_get_referents(song_id = song$id)

# Number of annotations = measure of cultural significance!
print(paste("This song has", nrow(annotations), "annotations"))
```

## 📊 What Data Can You Get?

### About Artists:
- Name, ID, and Genius URL
- Verification status
- Community IQ score
- Complete discography

### About Songs:
- Title, artist, and release date
- Genius URL
- Page views (popularity!)
- Lyrics state (complete/incomplete)
- Cover art URL
- All annotations/interpretations

### About Cultural Engagement:
- Lyric annotations (crowdsourced interpretations)
- Page view counts
- Community contributions
- Annotation counts per song

## 🎯 Functions You'll Use Most

All functions return data frames that you can immediately save to Excel:

```r
# Artist functions
genius_get_artist_details_df("Artist Name")           # Get artist info
genius_get_all_songs_from_artist("artist_id")         # Get all songs

# Song functions
genius_get_song_details_df("Song Name")               # Get song info
genius_get_referents(song_id = "12345")               # Get annotations

# Search functions
genius_get_search_results("search term")              # General search
```

**Don't worry about remembering these!** The vignette has copy-paste examples for everything.

## 💾 Exporting Your Data

All rapR data can be easily exported:

### To Excel (Recommended for most researchers):
```r
library(writexl)
write_xlsx(your_data, "filename.xlsx")
```

### To CSV (for SPSS, Python, etc.):
```r
write.csv(your_data, "filename.csv", row.names = FALSE)
```

### To R data file (for R users):
```r
saveRDS(your_data, "filename.rds")
```

## ❓ Common Questions

**Q: I've never used R before. Can I still use this?**
A: Yes! Our vignette walks you through everything. If you can copy and paste, you can use rapR.

**Q: Do I need to pay for the API?**
A: No! Genius API is completely free.

**Q: What if I search for a song and get multiple results?**
A: rapR will show you the options and ask you to pick the right one - just type the number!

**Q: Can I analyze the data in Excel or SPSS instead of R?**
A: Absolutely! Use rapR to collect the data, then analyze it in whatever tool you prefer.

**Q: I got an error. What do I do?**
A: Check the troubleshooting section in the vignette, or [open an issue](https://github.com/phdemotions/rapR/issues) - we're here to help!

## 📖 Learning Resources

### If you're new to R:
- [RStudio Education](https://education.rstudio.com/) - Free R tutorials
- [R for Data Science](https://r4ds.had.co.nz/) - Free online book
- Our vignette: `vignette("getting-started", package = "rapR")`

### If you want to do analysis in R:
- [dplyr for data manipulation](https://dplyr.tidyverse.org/)
- [ggplot2 for visualization](https://ggplot2.tidyverse.org/)
- [tidytext for text analysis](https://www.tidytextmining.com/)

## 🤝 Getting Help

- 📘 **Start here**: View the vignette with `vignette("getting-started", package = "rapR")`
- 🐛 **Found a bug?** [Open an issue](https://github.com/phdemotions/rapR/issues)
- ❓ **Have a question?** [Ask on GitHub](https://github.com/phdemotions/rapR/issues/new)
- 💬 **Want to share your research?** We'd love to hear how you use rapR!

## 📄 Citation

If you use rapR in your research, please cite it:

```r
citation("rapR")
```

Gonzales, J. (2024). rapR: R Interface for Using Genius and Spotify API. R package version 0.1.0. https://github.com/phdemotions/rapR

## 🙏 Acknowledgements

- The [Genius](https://genius.com) platform for providing a free API
- The R community for packages that make this possible: [httr](https://httr.r-lib.org/), [jsonlite](https://github.com/jeroen/jsonlite), [dplyr](https://dplyr.tidyverse.org/)

## 📜 License

MIT License - See LICENSE file for details.

---

**Ready to start your research?** Install rapR and check out the vignette:

```r
remotes::install_github("phdemotions/rapR")
vignette("getting-started", package = "rapR")
```

**Questions?** Open an issue - we're here to help researchers succeed! 🎵
