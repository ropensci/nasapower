
library("vcr") # *Required* as vcr is set up on loading
invisible(vcr::vcr_configure(
  dir = vcr::vcr_test_path("fixtures")
))
vcr::vcr_configure(serialize_with = "json")
vcr::check_cassette_names()

if (!nzchar(Sys.getenv("GITHUB_PAT"))) {
  if (dir.exists(dir)) {
    # Fake API token to fool our package
    Sys.setenv("GITHUB_PAT" = "foobar")
  } else {
    # If there's no mock files nor API token, impossible to run tests
    stop("No API key nor cassettes, tests cannot be run.",
         call. = FALSE)
  }
}
