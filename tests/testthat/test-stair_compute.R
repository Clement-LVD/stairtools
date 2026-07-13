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

 test_that("stair_compute accepts arrival landing", {

  result <- stair_compute(
    height = 1000,
    max_run = 3000,
    last_step_is_landing = TRUE,
    end_depth = 500
  )

  expect_equal(
    result$end$depth,
    500
  )

})

# last step :
test_that("landing flag affects geometry labels", {

  s <- stair_compute(
    height = 840,
    max_run = 2000,
    last_step_is_landing = TRUE
  )

  expect_equal(
    s$geometry$steps$type[1],
    "floor"
  )

  expect_equal(
    tail(s$geometry$steps$type, 1),
    "landing"
  )

})

test_that("arrival landing increases horizontal geometry", {

  s_no_landing <- stair_compute(
    height = 840,
    max_run = 2000,
    last_step_is_landing = FALSE
  )

 s_landing <- stair_compute(
  height = 840,
  max_run = 2000,
  last_step_is_landing = TRUE,
  end_depth = 500
)

  expect_gt(
    max(s_landing$geometry$steps$x),
    max(s_no_landing$geometry$steps$x)
  )

})

test_that("arrival landing consumes available run", {

  s1 <- stair_compute(
    height = 840,
    max_run = 2000
  )

  s2 <- stair_compute(
    height = 840,
    max_run = 2000,
    last_step_is_landing = TRUE
  )

  s3 <- stair_compute(
    height = 840,
    max_run = 2000,
    last_step_is_landing = TRUE,
    end_depth = 1000
  )


  expect_equal(
    s1$geometry$overall_run,
    1176
  )

  expect_equal(
    s2$geometry$overall_run,
    1470
  )

  expect_equal(
    s3$geometry$overall_run,
    2000
  )

})
