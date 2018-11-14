
#context("http error handling")

#test_that("no 404 http errors are handled as expected", {
#  memoise::forget(GETcontent)
#  skip_on_cran()
#  webmockr::enable()
#  stub <- webmockr::stub_request("get", "https://haveibeenpwned.com/api/breaches") # nolint
#  webmockr::to_return(stub, status = 429)
#  expect_message(HIBPwned::breached_sites(), "Try")
#  expect_silent(HIBPwned::breached_sites(verbose = FALSE))
#  output <- HIBPwned::breached_sites()
#  expect_null(output)
#  webmockr::disable()
#})

#test_that("404 http errors are handled as expected", {
#  memoise::forget(GETcontent)
#  skip_on_cran()
#  webmockr::enable()
#  stub <- webmockr::stub_request("get", "https://haveibeenpwned.com/api/breaches") # nolint
#  webmockr::to_return(stub, status = 404)
#  output <- HIBPwned::breached_sites()
#  expect_is(output, "data.frame")
#  expect_true(is.na(output$Name))
#  webmockr::disable()
#})