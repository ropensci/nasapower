
.onAttach <- function(libname, pkgname) {
  msg <- paste0("While nasapower does not redistribute the data in anyway,\n",
                "we encourage users to follow the requests of the POWER\n",
                "Project Team:\n",
                "\n",
                "'When POWER data products are used in a publication, we\n",
                "request the following acknowledgment be included:\n",
                "These data were obtained from the NASA Langley Research\n",
                "Center POWER Project funded through the NASA Earth Science\n",
                "Directorate Applied Science Program.'\n")
  packageStartupMessage(msg)
}
