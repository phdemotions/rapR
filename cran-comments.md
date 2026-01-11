## R CMD check results

0 ERRORs | 0 WARNINGs | 1 NOTE

* checking CRAN incoming feasibility ... NOTE
  Maintainer: 'Josh Gonzales <jgonza10@uoguelph.ca>'

  New submission

  Conflicting package names (submitted: rapR, existing: rapr)

### Justification for package name

The package name "rapR" is intentionally chosen to reflect its purpose: providing an R interface for retrieving rap music data from Genius and Spotify APIs. While there is an existing package "rapr" on CRAN, these packages serve completely different purposes:

- **rapR**: Interface for Genius and Spotify API to retrieve rap music annotations, lyrics, and metadata
- **rapr**: (Different package with unrelated functionality)

The capitalization difference (rapR vs rapr) and distinct functionality make these packages sufficiently distinguishable for users.

## Test environments

* local: macOS 15.6.1, R 4.3.1
* GitHub Actions:
  - ubuntu-latest (R release)
  - ubuntu-latest (R devel)
  - macos-latest (R release)
  - windows-latest (R release)

## Additional notes

* All examples requiring network access to external APIs are wrapped in `\dontrun{}` as they require authentication tokens
* Tests requiring the GENIUS_API_TOKEN are properly skipped when the token is not available using `skip_if()` and `skip_on_cran()`
