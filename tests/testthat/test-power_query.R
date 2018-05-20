
# test queries -----------------------------------------------------------------
context("power_query")
test_that("SinglePoint identifiers return the proper query_list", {
  pars <-  c(
    "T2M",
    "T2MN",
    "T2MX",
    "RH2M",
    "toa_dwn",
    "swv_dwn",
    "lwv_dwn",
    "DFP2M",
    "RAIN",
    "WS10M"
  )
  lonlat_id <- check_lonlat(lonlat = c(-179.5, -89.5), pars)
  dates <- c("1983-01-01", "1983-02-02")
  dates <- check_dates(dates)

  query_list <- power_query(community = "AG",
                            lonlat_identifier = lonlat_id,
                            pars = pars,
                            dates = dates,
                            temporal_average = "Daily")

})
