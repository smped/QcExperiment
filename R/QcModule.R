#' Create an object of class QcModule
#'
#' @details
#' This will coerce a data.frame or matrix into the correct structure to be a
#' QcModule. QcModule objects are data.frames set as S4 objects with optional
#' attributes 'tool' and 'version'
#'
#'
#' @param data A data.frame containing data from a given bioinformatics tool
#' @param tool optional. The name of the tool used, e.g. "samtools stats"
#' @param version optional. The tool version(s) used as a character vector
#' @param ... Not used
#'
#' @examples
#' ## Create a simple object
#' mod <- QcModule(pressure, tool = "example")
#' mod
#' attributes(mod)
#'
#'
#' @return An object of class QcModule
#' @export
QcModule <- function(data, tool = NULL, version = NULL, ...){
  UseMethod("QcModule")
}
#' @importFrom methods new
#' @export
#' @aliases QcModule
QcModule.data.frame <- function(data, tool = NULL, version = NULL, ...){

  old_attr <- attributes(data)
  new_attr <- list(tool = tool, version = version)
  attributes(data) <- c(old_attr, new_attr)
  new("QcModule", data)

}
#' @export
#' @aliases QcModule
QcModule.matrix <- function(data, tool = NULL, version = NULL, ...){

  data <- as.data.frame(data)
  QcModule.data.frame(data, tool, version, ...)

}



# test <- new_class(
#   "test",
#   parent = class_data.frame,
#   constructor = function(data = data.frame(), tool = NULL, version = NULL) {
#
#     old_attr <- attributes(data)
#     new_attr <- list(tool = tool, version = version)
#     attributes(data) <- c(old_attr, new_attr)
#
#     new_object("test", .data = data)
#
#   }
# )
