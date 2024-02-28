source("helpers.R")
using("tinysnapshot")

f = function() {
  plot(0:10, main = "plot")
}
expect_snapshot_plot(f, label = "plot")
