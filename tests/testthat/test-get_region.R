context("get_region")

test_that("get_region returns a valid data frame and multiple dates", {
  x <- get_region(
    lonlat = c(-179.5, -178.5, 89.5, 89.5),
    stdate = "2017-1-1",
    endate = "2017-1-2"
  )
  expect_is(x, "data.frame")
  expect_equal(sum(!duplicated(x["DOY"])), 2)
})

test_that("get_region stops if there are not four values supplied to lonlat", {
  expect_error(test <-
                 get_region(
                   lonlat = c(-179.5, -178.5, -89.5),
                   stdate = "2017-1-1",
                   endate = "2017-1-1"
                 ))
})

test_that("get_region emits a message when RAIN requested outside provision",
          {
            expect_message(get_region(
              lonlat = c(-179.5, -178.5, 89.5, 89.5),
              vars = c("T2M", "RAIN"),
              stdate = "1987-1-1",
              endate = "1987-1-1"
            ))
          })
