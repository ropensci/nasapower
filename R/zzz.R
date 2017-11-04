
.onLoad <-
  function(libname = find.package("nasapower"),
           pkgname = "nasapower") {
    # CRAN Note avoidance
    if (getRversion() >= "2.15.1") {
      utils::globalVariables(c("."))
    }
  }


.onAttach <- function(libname, pkgname) {
  msg <- paste0("While nasapower does not redistribute the data or provide\n",
                "in anyway, we encourage users to follow the requests of the\n",
                "POWER Project Team.",
                "\n",
                "`When POWER data products are used in a publication, we\n",
                "request the following acknowledgment be included:\n",
                "These data were obtained from the NASA Langley Research\n",
                "Center POWER Project funded through the NASA Earth Science\n",
                "Directorate Applied Science Program.`\n")
  packageStartupMessage(msg)
}
