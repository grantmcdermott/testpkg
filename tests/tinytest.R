
if (requireNamespace("tinytest", quietly = TRUE)) {
  # tinytest::test_package("testpkg")
  tinytest::test_package("testpkg", testdir="testsuite/tinytest")
}

