# testpkg

Example repo for offloading an R package's test suite into a Git submodule.
The sister repo (i.e., the actual submodule) is
[here](https://github.com/grantmcdermott/testpkg-testsuite).

## Motivation

**Problem:** Imagine that you are developing an R package. Like any good package
maintainer, you have added loads of unit tests, backed by a CI framework (e.g.,
GitHub Actions), to help ensure the quality of your package. Unfortunately,
there's downside to being a good maintainer. In your case, the test artifacts
themselves are taking up a lot of space. Maybe it's because your tests are run
against inherently large objects like [image
snapshots](https://github.com/vincentarelbundock/tinysnapshot). Or, maybe you
just have to deal with really big datasets. Whatever the case, these large
test artifacts are pushing you above CRAN's recommended 5 MB installation limit.

**Solution:** Instead of bundling your tests as part of main R package (repo), you
can offload them into a sister repo as a
[Git submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules). This sidesteps
the whole large artifact problem (since tests live outside of the main package),
helping to reduce the installation size of your package, and keep it within CRAN's
recommended limits

Note the implicit tradeoff: Since we don't bundle the tests as part of
the main package, this means that all tests are going to be skipped on CRAN once
we submit our package. Testing is only done locally or via GitHub Actions CI.
For many package developers, this is likely to be an acceptable (desirable
even!) tradeoff. After all, you can still provision a comprehensive and
automated testing suite via GH Actions, which will run whenever you receive a
pull request or make direct changes to your repo.

## Try it yourself

### Step 1: Clone the repo and testsuite submodule

When you first clone the repo (package), make sure to pull in the
`tests/testsuite` submodule too. 

```sh
git clone --recursive-submodules https://github.com/grantmcdermott/testpkg.git
```

Alternatively, if you have already cloned the repo in a way that doesn't grab
any submodules---which is very likely to be the case if you cloned the repo
through an IDE like VS Code or RStudio---then simply initiate and update the
submodule.

```sh
# git clone https://github.com/grantmcdermott/testpkg.git # Clone the main repo
git submodule update --init --recursive                   # Add any submodules
```

### Step 2: Run the tests

I am using the **tinytest** framework for this example repo. By default,
**tinytest** expects that all tests live in the `tests/tinytest` directory. So,
the only change we need to make is telling it to look for tests in our
`tests/testsuite` submodule instead. For interactive testing:

```r
tinytest::run_test_dir("tests/testsuite")                   ## run all tests
tinytest::run_test_file("tests/testsuite/test_myplot.R")    ## run a single test file
# etc
```

For testing as part of `R CMD check` (or, equivalently `devtools::check()`), we
handle the non-standard test suite location for users automatically in
`tests/tinytest.R`
[here](https://github.com/grantmcdermott/testpkg/blob/main/tests/tinytest.R):

```r
if (requireNamespace("tinytest", quietly = TRUE)) {
  tinytest::test_package("testpkg", testdir="testsuite")
}
```

The same concepts and adjustments should carry over directly to other testing
frameworks like **testthat**.

Easy!

## Under the hood

### GitHub Actions

This all works on GH Actions because of a lightly modified workflow file. In
short, all you need to do is tell your main checkout action to include any
submodules. Here's what that
[looks like](https://github.com/grantmcdermott/testpkg/blob/main/.github/workflows/R-CMD-check.yaml#L28-L32)
for my file.

```yaml
   steps:
      - uses: actions/checkout@v3
        with:                           # added
          submodules: 'recursive'       # added
```

### Adding new tests

You can add tests directly to your submodule repo upstream remote
([here](https://github.com/grantmcdermott/testpkg-testsuite),
in this case). Just make sure that you adjust your parent repo to pull in these
changes.

An easier approach is probably just to do everything locally from the parent
repo. This requires two steps and is most easily done from you terminal. For
example, assume that I have added a new test to my local clone of my
`tests/testsuite` submodule...

First step:  Make sure the local changes changes are commited and pushed to the
main branch of our upstream remote.

```sh
cd tests/testsuite
git checkout main
git add -A
git commit -m "some new tests"
git push origin main
```

Second step: Update the parent repo to pull in the latest submodule commit.

```sh
# Update the parent repo remote
cd ../..
git add tests/testsuite
git commit -m "Update submodule to latest commit"
git push origin main
```




