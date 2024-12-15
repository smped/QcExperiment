setOldClass("data.frame")
setClass(
  ## This allows S4 behaviour for a data.frame with all S3 methods inherited.
  ## Additional methods can be defined.
  ## This also allows for data.table and tibble objects to be used as they
  ## inherit from data.frame
  "QcModule", contains = "data.frame"
)

setValidity("QcModule", function(object) {
  attr <- attributes(object)
  msg <- c()
  if (length(attr$tool)) {
    if (!is.character(attr$tool) | length(attr$tool) > 1) {
      msg <- c(msg, "tool must be provided as character(1)")
    }
  }
  if (length(attr$version)) {
    if (!is.character(attr$version) | length(attr$version) > 1) {
      msg <- c(msg, "version must be provided as character(1)")
    }
  }
  if (!is.null(msg)) return(msg)
  TRUE
})

## Needed custom methods are:
##
## - as.data.frame: as(qcMod, "data.frame") works, but as.data.frame(qcMod) doesn't.
##   This should also handle tibble coercion
##
## - subsetting by rows qcMod[1:5, ] will return an S3 data frame with intact attributes but the S4 class lost
##
## - rbind may require some thought wrt handling of the additional attributes
##
## - tool & version
##
## dplyr methods can be used after coercion to a tibble
##
## How to handle sample/rownames is also important
