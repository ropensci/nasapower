context(".check_response")
# Check that .check_response handles invalid years -----------------------------

test_that(".check_response stops if server not responding", {
  url <- "www.notreal.t"
  expect_error(.check_response(url))
})