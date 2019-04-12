m <- as.data.frame(which(is.na(airquality), arr.ind = TRUE))
col_names <- names(airquality)[unique(m[, 2])][match(m[, 2], c(unique(m[, 2])))]
m <- data.frame(col_names, m[, c(2, 1)])

