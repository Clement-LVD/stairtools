test_that("check_numeric accepts valid numeric values", {

  expect_no_error(
    check_numeric(10, "value")
  )

  expect_no_error(
    check_numeric(10.5, "value")
  )

})


test_that("check_numeric rejects non numeric values", {

  expect_error(
    check_numeric("10", "value"),
    "value must be a finite numeric value"
  )

  expect_error(
    check_numeric(TRUE, "value"),
    "value must be a finite numeric value"
  )

})


test_that("check_numeric rejects missing values", {

  expect_error(
    check_numeric(NA, "value"),
    "value must be a finite numeric value"
  )

  expect_error(
    check_numeric(NaN, "value"),
    "value must be a finite numeric value"
  )

})


test_that("check_numeric rejects infinite values", {

  expect_error(
    check_numeric(Inf, "value"),
    "value must be a finite numeric value"
  )

  expect_error(
    check_numeric(-Inf, "value"),
    "value must be a finite numeric value"
  )

})


test_that("check_numeric rejects vectors", {

  expect_error(
    check_numeric(c(1, 2), "value"),
    "value must be a finite numeric value"
  )

})