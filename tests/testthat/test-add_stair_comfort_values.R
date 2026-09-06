test_that("add_stair_comfort_values computes comfort indicators", {

  x <- data.frame(
    step_rise = c(16, 18.3, 20),
    going = c(25, 28, 31)
  )

  result <- add_stair_comfort_values(x, .verbose = FALSE)

  expect_equal(
    result$slope_angle,
    atan(c(16 / 25, 18.3 / 28, 20 / 31)) * 180 / pi
  )

  expect_equal(
    result$acceptable_slope_angle,
    c(TRUE, TRUE, TRUE)
  )

  expect_equal(
    result$rise_going_ratio,
    c(16 / 25, 18.3 / 28, 20 / 31)
  )

  expect_equal(
    as.character(result$comfort),
    c("comfortable", "comfortable", "comfortable")
  )

  expect_equal(
    result$rise_preference_deviation,
    c(-2.3, 0, 1.7)
  )

  expect_equal(
    result$going_preference_deviation,
    c(-2.9, 0, 1)
  )
})


test_that("comfort classes are correctly assigned", {

  x <- data.frame(
    step_rise = c(7.7, 9, 10, 14),
    going = c(10, 10, 10, 10)
  )

  result <- add_stair_comfort_values(x, .verbose = FALSE)

  expect_equal(
    as.character(result$comfort),
    c("comfortable", "normal", "steep", "uncomfortable")
  )
})


test_that("add_stair_comfort_values accepts slope boundaries", {

  x <- data.frame(
    step_rise = c(tan(17 * pi / 180) * 10,
                  tan(48 * pi / 180) * 10),
    going = 10
  )

  result <- add_stair_comfort_values(x, .verbose = FALSE)

  expect_equal(
    result$acceptable_slope_angle,
    c(TRUE, TRUE)
  )
})


test_that("add_stair_comfort_values requires step_rise and going", {

  expect_error(
    add_stair_comfort_values(
      data.frame(step_rise = 16),
      .verbose = FALSE
    ),
    "`x` must contain `step_rise` and `going`"
  )

  expect_error(
    add_stair_comfort_values(
      data.frame(going = 28),
      .verbose = FALSE
    ),
    "`x` must contain `step_rise` and `going`"
  )
})