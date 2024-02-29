# skip tests on CRAN
run_tests = identical(tolower(Sys.getenv("NOT_CRAN")), "true")

if (run_tests && requireNamespace("tinytest", quietly = TRUE)) {
  tinytest::test_package("testpkg", testdir = "testsuite")
}