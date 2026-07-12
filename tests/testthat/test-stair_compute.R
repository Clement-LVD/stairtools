test_that("stair_compute returns a stair_solution object", {

  result <- stair_compute(
    height = 804,
    max_run = 10000
  )

  expect_s3_class(result, "stair_solution")

})


test_that("stair_compute respects Blondel target", {

  result <- stair_compute(
    height = 804,
    max_run = 10000
  )

  expect_equal(
    result$geometry$blondel,
    630,
    tolerance = 0.1
  )

})


test_that("stair_compute does not use unnecessary available space", {

  result <- stair_compute(
    height = 804,
    max_run = 10000
  )

  expect_gt(
    result$unused_run,
    8000
  )

})


test_that("stair_compute reduces going when space is limited", {

  result <- stair_compute(
    height = 3000,
    max_run = 6000
  )

  expect_lte(
    result$build$overall_run,
    6000
  )

})


test_that("stair_compute rejects insufficient space", {

  expect_error(
    stair_compute(
      height = 3000,
      max_run = 500
    )
  )

})


test_that("stair_compute accepts landings", {

  result <- stair_compute(
    height = 1000,
    max_run = 3000,
    start = landing(depth = 500),
    end = landing(depth = 500)
  )

  expect_equal(
    result$start$depth,
    500
  )

})