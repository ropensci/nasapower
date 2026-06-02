test_that(".get_timeout() returns default when option is unset", {
  withr::with_options(
    list(nasapower.timeout = NULL),
    expect_identical(.get_timeout(), 10L)
  )
})

test_that(".get_timeout() returns user-set integer value", {
  withr::with_options(
    list(nasapower.timeout = 60L),
    expect_identical(.get_timeout(), 60L)
  )
})

test_that(".get_timeout() coerces valid numeric to integer", {
  withr::with_options(
    list(nasapower.timeout = 60),
    expect_identical(.get_timeout(), 60L)
  )
})

test_that(".get_timeout() warns and returns default for zero", {
  withr::with_options(
    list(nasapower.timeout = 0L),
    expect_warning(
      expect_identical(.get_timeout(), 10L),
      regexp = "nasapower.timeout"
    )
  )
})

test_that(".get_timeout() warns and returns default for negative value", {
  withr::with_options(
    list(nasapower.timeout = -5L),
    expect_warning(
      expect_identical(.get_timeout(), 10L),
      regexp = "nasapower.timeout"
    )
  )
})

test_that(".get_timeout() warns and returns default for non-numeric", {
  withr::with_options(
    list(nasapower.timeout = "fast"),
    expect_warning(
      expect_identical(.get_timeout(), 10L),
      regexp = "nasapower.timeout"
    )
  )
})

test_that(".get_timeout() warns and returns default for TRUE", {
  withr::with_options(
    list(nasapower.timeout = TRUE),
    expect_warning(
      expect_identical(.get_timeout(), 10L),
      regexp = "nasapower.timeout"
    )
  )
})

test_that(".get_timeout() warns and returns default for length > 1", {
  withr::with_options(
    list(nasapower.timeout = c(10L, 20L)),
    expect_warning(
      expect_identical(.get_timeout(), 10L),
      regexp = "nasapower.timeout"
    )
  )
})

# ---- .get_timeout_connect() -------------------------------------------------

test_that(".get_timeout_connect() returns default when option is unset", {
  withr::with_options(
    list(nasapower.timeout.connect = NULL),
    expect_identical(.get_timeout_connect(), 5L)
  )
})

test_that(".get_timeout_connect() returns user-set integer value", {
  withr::with_options(
    list(nasapower.timeout.connect = 15L),
    expect_identical(.get_timeout_connect(), 15L)
  )
})

test_that(".get_timeout_connect() coerces valid numeric to integer", {
  withr::with_options(
    list(nasapower.timeout.connect = 15),
    expect_identical(.get_timeout_connect(), 15L)
  )
})

test_that(".get_timeout_connect() warns and returns default for zero", {
  withr::with_options(
    list(nasapower.timeout.connect = 0L),
    expect_warning(
      expect_identical(.get_timeout_connect(), 5L),
      regexp = "nasapower.timeout.connect"
    )
  )
})

test_that(".get_timeout_connect() warns and returns default for negative value", {
  withr::with_options(
    list(nasapower.timeout.connect = -1L),
    expect_warning(
      expect_identical(.get_timeout_connect(), 5L),
      regexp = "nasapower.timeout.connect"
    )
  )
})

test_that(".get_timeout_connect() warns and returns default for non-numeric", {
  withr::with_options(
    list(nasapower.timeout.connect = "fast"),
    expect_warning(
      expect_identical(.get_timeout_connect(), 5L),
      regexp = "nasapower.timeout.connect"
    )
  )
})

test_that(".get_timeout_connect() warns and returns default for TRUE", {
  withr::with_options(
    list(nasapower.timeout.connect = TRUE),
    expect_warning(
      expect_identical(.get_timeout_connect(), 5L),
      regexp = "nasapower.timeout.connect"
    )
  )
})

test_that(".get_timeout_connect() warns and returns default for length > 1", {
  withr::with_options(
    list(nasapower.timeout.connect = c(5L, 10L)),
    expect_warning(
      expect_identical(.get_timeout_connect(), 5L),
      regexp = "nasapower.timeout.connect"
    )
  )
})

# ---- .get_max_tries() -------------------------------------------------------

test_that(".get_max_tries() returns default when option is unset", {
  withr::with_options(
    list(nasapower.max_tries = NULL),
    expect_identical(.get_max_tries(), 6L)
  )
})

test_that(".get_max_tries() returns user-set integer value", {
  withr::with_options(
    list(nasapower.max_tries = 3L),
    expect_identical(.get_max_tries(), 3L)
  )
})

test_that(".get_max_tries() coerces valid numeric to integer", {
  withr::with_options(
    list(nasapower.max_tries = 3),
    expect_identical(.get_max_tries(), 3L)
  )
})

test_that(".get_max_tries() accepts 1L (retries disabled)", {
  withr::with_options(
    list(nasapower.max_tries = 1L),
    expect_identical(.get_max_tries(), 1L)
  )
})

test_that(".get_max_tries() warns and returns default for zero", {
  withr::with_options(
    list(nasapower.max_tries = 0L),
    expect_warning(
      expect_identical(.get_max_tries(), 6L),
      regexp = "nasapower.max_tries"
    )
  )
})

test_that(".get_max_tries() warns and returns default for negative value", {
  withr::with_options(
    list(nasapower.max_tries = -1L),
    expect_warning(
      expect_identical(.get_max_tries(), 6L),
      regexp = "nasapower.max_tries"
    )
  )
})

test_that(".get_max_tries() warns and returns default for non-numeric", {
  withr::with_options(
    list(nasapower.max_tries = "many"),
    expect_warning(
      expect_identical(.get_max_tries(), 6L),
      regexp = "nasapower.max_tries"
    )
  )
})

test_that(".get_max_tries() warns and returns default for TRUE", {
  withr::with_options(
    list(nasapower.max_tries = TRUE),
    expect_warning(
      expect_identical(.get_max_tries(), 6L),
      regexp = "nasapower.max_tries"
    )
  )
})

test_that(".get_max_tries() warns and returns default for length > 1", {
  withr::with_options(
    list(nasapower.max_tries = c(3L, 6L)),
    expect_warning(
      expect_identical(.get_max_tries(), 6L),
      regexp = "nasapower.max_tries"
    )
  )
})

# ---- option isolation -------------------------------------------------------

test_that("options do not leak between tests", {
  withr::with_options(
    list(nasapower.timeout = 99L),
    expect_identical(.get_timeout(), 99L)
  )
  # outside the with_options block the option should be gone
  withr::with_options(
    list(nasapower.timeout = NULL),
    expect_identical(.get_timeout(), 10L)
  )
})
