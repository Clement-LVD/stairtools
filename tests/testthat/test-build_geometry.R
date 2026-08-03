test_that("build_geometry returns a valid stair_geometry object", {
  geo <- build_geometry(5, 17.33, rep(28.33, 4))

  expect_s3_class(geo, "stair_geometry")
  expect_true(all(c(
    "step",
    "x_riser",
    "y_bottom",
    "y_top",
    "going",
    "x_going_end"
  ) %in% names(geo)))

  expect_equal(nrow(geo), 5)
})

test_that("plot works with stair_geometry objects", {
  geo <- build_geometry(5, 17.33, rep(28.33, 4))

  expect_silent(plot(geo))
})