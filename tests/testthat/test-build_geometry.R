test_that("build_geometry returns a valid stair_geometry object", {

  geo <- build_geometry(5, 17.33, rep(28.33, 4))

  expect_s3_class(geo, "stair_geometry")

  expect_true(all(c(
    "step",
    "x_step_start",
    "y_bottom",
    "y_top",
    "rise",
    "going",
    "x_going_end",
    "has_tread"
  ) %in% names(geo)))

  expect_equal(nrow(geo), 5)
})

test_that("build_geometry() fail when given incoherent number of steps", {
 
  testthat::expect_error(geo <- build_geometry(15, 17.33, rep(28.33, 4)))

  testthat::expect_error(geo <- build_geometry(2, 17.33, rep(28.33, 4)))

})