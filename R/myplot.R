##' A placeholder function using roxygen
##'
##' A thin wrapper around base plot.
##' @param ... Passed to plot.
##' @return A plot
##' @examples
##' myplot(1:10)
##' @export
myplot <- function(...) {
  plot(..., main = "Produced by myplot")
}
