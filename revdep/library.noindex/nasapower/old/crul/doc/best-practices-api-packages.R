## ----eval=FALSE----------------------------------------------------------
#  xGET <- function(url, path, args = list(), ...) {
#    cli <- crul::HttpClient$new(url, opts = list(...))
#    res <- cli$get(path = path, query = args)
#    res$raise_for_status()
#    res$parse("UTF-8")
#  }

## ----eval=FALSE----------------------------------------------------------
#  x <- xGET("https://httpbin.org", "get", args = list(foo = "bar"))
#  # parse the JSON to a list
#  jsonlite::fromJSON(x)
#  # more parsing

## ----eval=FALSE----------------------------------------------------------
#  xGET("https://xxx.org", args = list(foo = "bar"), verbose = TRUE)

