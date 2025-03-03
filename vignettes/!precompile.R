# vignette that depends on Internet access need to be pre-compiled and takes a
# while to run
library("knitr")
knit("vignettes/nasapower.Rmd.orig", "vignettes/nasapower.Rmd")

# remove file path such that vignettes will build with figures
replace <- readLines("vignettes/nasapower.Rmd")
replace <- gsub("<img src=\"vignettes/", "<img src=\"", replace)
fileConn <- file("vignettes/nasapower.Rmd")
writeLines(replace, fileConn)
close(fileConn)

# build vignette
library("devtools")
build_vignettes()

# move resource files to /docs
resources <-
  list.files("vignettes/", pattern = ".png$", full.names = TRUE)
file.copy(from = resources, to = "docs", overwrite = TRUE)
