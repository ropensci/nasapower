
# community checks -------------------------------------------------------------
context("check_community")
test_that("check_community fails if one not provided", {
  expect_error(check_community(NULL),
               regexp = "*You have not provided a `community` value.*")
})

test_that("check_community fails if invalid entry is supplied", {
  expect_error(check_community("R"),
               regexp = "*You have provided an invalid `community` value.*")
})
