# Borrowed from opencage, https://github.com/ropensci/opencage/blob/main/R/zzz.R
# We use `<<-` below to modify the package's namespace.
# It doesn't modify the global environment.
# We do this to prevent build time dependencies on {memoise} and {ratelimitr},
# as recommended in <http://memoise.r-lib.org/reference/memoise.html#details>.
# Cf. <https://github.com/r-lib/memoise/issues/76> for further details.

# First make sure that the functions are defined at build time
# .send_query() can be found in internal_functions.R
.send_query_limited <- .send_query
.send_query_limited_hourly <- .send_query

# Then modify them at load-time
# nocov start
.onLoad <- function(libname, pkgname) {
  # nolint because snake_case
  # limit requests per second

  .send_query_limited <<-
    ratelimitr::limit_rate(f = .send_query,
                           ratelimitr::rate(n = 1L,
                                            period = 30L))
  .send_query_limited_hourly <<-
    ratelimitr::limit_rate(f = .send_query,
                           ratelimitr::rate(n = 1L,
                                            period = 60L))
}
# nocov end
