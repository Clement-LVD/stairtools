test_that("plot_stair works with stair_geometry objects", {

  geometry <- build_geometry(
    n_steps = 5,
    step_height = 17.33,
    going = rep(28.33, 4)
  )

  expect_s3_class(geometry, "stair_geometry")

  expect_silent(
    plot_stair(geometry)
  )

  expect_silent(
    plot(geometry)
  )
})


test_that("plot_stair supports dimensions display", {

  geometry <- build_geometry(
    n_steps = 5,
    step_height = 17.33,
    going = rep(28.33, 4)
  )

  expect_silent(
    plot_stair(
      geometry,
      show_dimensions = TRUE
    )
  )

  expect_silent(
    plot_stair_dimensions(geometry)
  )
})


test_that("plot_stair handles missing final going", {

  geometry <- build_geometry(
    n_steps = 5,
    step_height = 17.33,
    going = rep(28.33, 4)
  )

  expect_true(
    any(is.na(geometry$going))
  )

  expect_silent(
    plot_stair(geometry)
  )
})


test_that("plot.stair_geometry dispatches correctly", {

  geometry <- build_geometry(
    n_steps = 3,
    step_height = 16,
    going = rep(30, 2)
  )

  expect_silent(
    plot(geometry)
  )

   expect_silent(
    plot(geometry, show_dimensions = TRUE)
  )
})