test_that("positive nosing extends intermediate treads beyond their going ends", {

  geometry <- data.frame(
    x_step_start = c(0, 23, 46),
    x_going_end = c(23, 46, NA),
    has_tread = c(TRUE, TRUE, FALSE)
  )

  result <- add_stair_surface_geometry(
    geometry,
    nosing = 4,
    nosing_direction = "positive"
  )

  expect_equal(result$x_tread_start, c(0, 23, 46))
  expect_equal(result$x_tread_end, c(27, 46, NA))
  expect_equal(result$x_riser, c(4, 27, 50))
})


test_that("negative nosing extends treads before their step origins", {

  geometry <- data.frame(
    x_step_start = c(0, 23, 46),
    x_going_end = c(23, 46, NA),
    has_tread = c(TRUE, TRUE, FALSE)
  )

  result <- add_stair_surface_geometry(
    geometry,
    nosing = 4,
    nosing_direction = "negative"
  )

  expect_equal(result$x_tread_start, c(-4, 19, 46))
  expect_equal(result$x_tread_end, c(23, 46, NA))
  expect_equal(result$x_riser, c(0, 23, 46))
})


test_that("surface geometry does not modify theoretical stair dimensions", {

  geometry <- data.frame(
    x_step_start = c(0, 23, 46),
    x_going_end = c(23, 46, NA),
    rise = c(20, 20, 20),
    going = c(23, 23, NA),
    has_tread = c(TRUE, TRUE, FALSE)
  )

  result <- add_stair_surface_geometry(
    geometry,
    nosing = 4,
    nosing_direction = "positive"
  )

  expect_equal(result$x_step_start, geometry$x_step_start)
  expect_equal(result$x_going_end, geometry$x_going_end)
  expect_equal(result$rise, geometry$rise)
  expect_equal(result$going, geometry$going)
})


test_that("zero nosing preserves theoretical tread coordinates", {

  geometry <- data.frame(
    x_step_start = c(0, 23, 46),
    x_going_end = c(23, 46, NA),
    has_tread = c(TRUE, TRUE, FALSE)
  )

  result <- add_stair_surface_geometry(
    geometry,
    nosing = 0,
    nosing_direction = "positive"
  )

  expect_equal(result$x_tread_start, geometry$x_step_start)
  expect_equal(result$x_tread_end, geometry$x_going_end)
  expect_equal(result$x_riser, geometry$x_step_start)
})


test_that("positive nosing also extends the last tread when present", {

  geometry <- data.frame(
    x_step_start = c(0, 30, 60),
    x_going_end = c(30, 60, 90),
    has_tread = c(TRUE, TRUE, TRUE)
  )

  result <- add_stair_surface_geometry(
    geometry,
    nosing = 4,
    nosing_direction = "positive"
  )

  expect_equal(result$x_tread_start, c(0, 30, 60))
  expect_equal(result$x_tread_end, c(34, 64, 90))
  expect_equal(result$x_riser, c(4, 34, 64))
})