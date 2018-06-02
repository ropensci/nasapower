#
# # test queries ----------------------------------------------------------------
context("Test that get_power queries the server and returns the proper
        requested data")
test_that("get_power returns AG data for a single point", {

  vcr::use_cassette("Single Point AG", {
    query_list <- get_power(community = "AG",
                            lonlat = c(-179.5, -89.5),
                            pars =  c("T2M",
                                      "T2M_MIN",
                                      "T2M_MAX",
                                      "RH2M",
                                      "WS10M"),
                            dates = c("1983-01-01", "1983-02-02"),
                            temporal_average = "Daily")
  })
})
