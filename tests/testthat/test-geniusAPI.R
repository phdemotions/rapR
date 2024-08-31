test_that("genius_get_annotation returns valid output", {
  expect_error(
    genius_get_annotation("invalid_id"),
    regexp = "Request failed with status: (401 Unauthorized|404 - Not Found: Annotation ID does not exist.)"
  )
})
