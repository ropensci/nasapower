# vignettes that depend on internet access need to be precompiled and take a
# while to run
library(knitr)
knit("vignettes/nasapower.Rmd.orig", "vignettes/nasapower.Rmd")
knit(
  "vignettes/nasapower_states_example.Rmd.orig",
  "vignettes/nasapower_states_example.Rmd"
)

# remove file path such that vignettes will build with figures
replace <- readLines("vignettes/nasapower.Rmd")
replace <- gsub("<img src=\"vignettes/", "<img src=\"", replace)
fileConn <- file("vignettes/nasapower.Rmd")
writeLines(replace, fileConn)
close(fileConn)

replace <- readLines("vignettes/nasapower_states_example.Rmd")
replace <- gsub("<img src=\"vignettes/", "<img src=\"", replace)
fileConn <- file("vignettes/nasapower_states_example.Rmd")
writeLines(replace, fileConn)
close(fileConn)

# build vignettes
library(devtools)
build_vignettes()

# move resource files to /doc
resources <-
  list.files("vignettes/", pattern = ".png$", full.names = TRUE)
file.copy(from = resources,
          to = "doc",
          overwrite =  TRUE)
