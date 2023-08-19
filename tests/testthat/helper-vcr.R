library("vcr") # *Required* as vcr is set up on loading
invisible(vcr::vcr_configure(
  dir = vcr::vcr_test_path("fixtures")
))
vcr::vcr_configure(serialize_with = "json")
vcr::check_cassette_names()
