
.onAttach <- function(libname, pkgname) { # nocov start
  msg <- paste0("While nasapower does not redistribute the data in any way,\n",
                "we encourage users to follow the requests of the POWER\n",
                "Project Team:\n",
                "\n",
                "'When POWER data products are used in a publication, we\n",
                "request the following acknowledgment be included:\n",
                "These data were obtained from the NASA Langley Research\n",
                "Center POWER Project funded through the NASA Earth Science\n",
                "Directorate Applied Science Program.'\n",
                "\n",
                "Please see `citation('nasapower')` for a proper citation of\n",
                "this package.\n")
  packageStartupMessage(msg)
}

# load parameters data frame in session
data("parameters", envir = environment()) # nocov end
