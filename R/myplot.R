##' A placeholder function using roxygen
##'
##' A thin wrapper around base plot.
##' @param ... Passed to plot.
##' @return A plot
##' @examples
##' myplot()
##' @export
myplot <- function(...) {
  plot(..., main = "Produced by myplot")
}
