test_that("genius_get_annotation returns valid output", {
  # Ensure the GENIUS_API_TOKEN is set for testing
  skip_if(Sys.getenv("GENIUS_API_TOKEN") == "", "GENIUS_API_TOKEN is not set.")

  # Use an invalid ID to test error handling
  expect_error(genius_get_annotation("invalid_id"), "Request failed with status: 401")
})
