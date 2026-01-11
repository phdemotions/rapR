test_that("genius_get_annotation returns valid output", {
  skip_if(Sys.getenv("GENIUS_API_TOKEN") == "", "GENIUS_API_TOKEN not set")
  skip_on_cran()

  expect_error(
    genius_get_annotation("invalid_id"),
    regexp = "Request failed with status: (401 Unauthorized|404 - Not Found: Annotation ID does not exist.)"
  )
})
