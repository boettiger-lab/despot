testthat::context("despot")


testthat::test_that("despot base functions generates a simulation", {


  model <- system.file("models/example.pomdp",  package = "despot")
  f <- tempfile()
  res <- solver(model, output = f)
  expect_true(file.exists(f))
  expect_is(res, "data.frame")
})
