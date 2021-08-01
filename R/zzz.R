# load parameters data frame in session
data("parameters", envir = environment()) # nocov

# create a 'base_url' object to be shared across functions. Putting it here in
# one spot makes it easy to update when the API changes rather than spread
# across the package in several spots
options("nasapower_base_url" =
          "https://power.larc.nasa.gov/beta/api/system/manager/")

