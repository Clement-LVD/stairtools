test_that("blondel_going computes the going from Blondel's formula", {
  expect_equal(
    blondel_going(rise = 16.25),
    30.5
  )

  expect_equal(
    blondel_going(rise = 20),
    23
  )
})


test_that("blondel_going uses the specified Blondel target", {
  expect_equal(
    blondel_going(rise = 17, blondel_target = 64),
    30
  )
})


test_that("blondel_going warns when rise is too large", {
  expect_warning(
    blondel_going(rise = 32),
    "Computed going is zero or negative"
  )
})
