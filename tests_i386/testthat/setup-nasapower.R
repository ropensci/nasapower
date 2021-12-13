library("vcr") # *Required* as 'vcr' is set up on loading
invisible(vcr::vcr_configure(dir = "../fixtures"))
vcr::check_cassette_names()
