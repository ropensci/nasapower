year <- sub("-.*", "", meta$Date)
note <- sprintf("R package version %s", meta$Version)

bibentry(bibtype = "Manual",
         title = "{nasapower}: NASA-POWER Agroclimatology Data from R",
         author = c(person("Adam", "Sparks")),
         year = year,
         note = note,
         DOI = "10.5281/zenodo.1040728",
         url = "https://github.com/adamhsparks/nasapower")