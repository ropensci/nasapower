context(".check_response")
# Check that .check_response handles web-site responses properly  --------------

test_that(".check_response stops if server not responding", {
  url <- "http://badurl.gov.au"
  expect_error(.check_response(url))
})

test_that(".check_response proceeds if server is responding", {
  url <- "https://www.google.com/"
  expect_warning(.check_response(url), regexp = NA)
})