test_that("stair_geometry returns a stair_geometry object", {

  rise <- stair_rise(3000)
  
  run <- stair_horizontal_run(
    n_rises = rise$n_rises,
    going = 250
  )

  result <- stair_geometry(rise, run)

  expect_s3_class(result, "stair_geometry")
  expect_true(is.list(result))

})

test_that("stair_geometry contains expected fields", {

  rise <- stair_rise(3000)

  run <- stair_horizontal_run(
    n_rises = rise$n_rises,
    going = 250
  )

  result <- stair_geometry(rise, run)

  expect_named(
    result,
    c(
      "profile",
      "steps",
      "height",
      "n_rises",
      "rise",
      "going",
      "flight_run",
      "overall_run",
      "blondel",
      "end",
      "units"
    )
  )

})

test_that("stair_geometry preserves rise and run dimensions", {

  rise <- stair_rise(3000)

  run <- stair_horizontal_run(
    n_rises = rise$n_rises,
    going = 250
  )

  result <- stair_geometry(rise, run)

  expect_equal(result$height, rise$height)
  expect_equal(result$n_rises, rise$n_rises)
  expect_equal(result$rise, rise$rise)
  expect_equal(result$going, run$going)
  expect_equal(result$flight_run, run$flight_run)
  expect_equal( result$overall_run, run$overall_run )

})


test_that("stair profile reaches final height", {

  rise <- stair_rise(3000)

  run <- stair_horizontal_run(
    n_rises = rise$n_rises,
    going = 250
  )

  result <- stair_geometry(rise, run)

  expect_equal(
    max(result$profile$y),
    rise$height
  )

})


test_that("stair geometry calculates Blondel value", {

  rise <- stair_rise(3000)

  run <- stair_horizontal_run(
    n_rises = rise$n_rises,
    going = 250
  )

  result <- stair_geometry(rise, run)

  expect_equal(
    result$blondel,
    2 * rise$rise + run$going
  )

})


test_that("number of tread steps matches run", {

  rise <- stair_rise(3000)

  run <- stair_horizontal_run(
    n_rises = rise$n_rises,
    going = 250
  )

  result <- stair_geometry(rise, run)

  expect_equal(
    sum(result$steps$type == "tread"),
    run$n_treads
  )

})

test_that("last landing option changes arrival type", {

  rise <- stair_rise(3000)

  run <- stair_horizontal_run(
    n_rises = rise$n_rises,
    going = 250,
    end = landing(depth = 1200, type = "end")
  )

  result <- stair_geometry(
    rise,
    run,
    last_step_is_landing = TRUE
  )

  expect_equal(
    tail(result$steps$type, 1),
    "landing"
  )

  expect_equal(
    tail(result$steps$depth, 1),
    1200
  )

  expect_equal(
    result$overall_run,
    run$flight_run + 1200
  )

})


test_that("invalid logical options give error", {

  rise <- stair_rise(3000)

  run <- stair_horizontal_run(
    n_rises = rise$n_rises,
    going = 250
  )
 
  expect_error(
    stair_geometry(
      rise,
      run,
      last_step_is_landing = "yes"
    ),
    "last_step_is_landing must be logical"
  )

})


test_that("invalid rise object gives error", {

  run <- stair_horizontal_run(
    n_rises = 18,
    going = 250
  )

  expect_error(
    stair_geometry(
      rise = list(),
      run = run
    ),
    "rise must be a stair_rise object"
  )

})


test_that("invalid run object gives error", {

  rise <- stair_rise(3000)

  expect_error(
    stair_geometry(
      rise = rise,
      run = list()
    ),
    "run must be a stair_run object"
  )

})


test_that("rise and run must describe same stair", {

  rise <- stair_rise(3000)

  run <- stair_horizontal_run(
    n_rises = 10,
    going = 250
  )

  expect_error(
    stair_geometry(
      rise,
      run
    ),
    "rise and run objects must describe the same number of rises"
  )

})


test_that("print method works", {

  rise <- stair_rise(3000)

  run <- stair_horizontal_run(
    n_rises = rise$n_rises,
    going = 250
  )

  result <- stair_geometry(rise, run)

  output <- capture.output(
    print(result)
  )

  expect_true(
    any(grepl("Stair geometry", output))
  )

})

test_that("plot method works", {

  skip_on_cran()

  rise <- stair_rise(3000)

  run <- stair_horizontal_run(
    n_rises = rise$n_rises,
    going = 250
  )

  result <- stair_geometry(rise, run)

  pdf(NULL)

  expect_silent(
    plot(result)
  )

  dev.off()

})

# without landing : no last step added
test_that("without landing option no arrival landing is added", {

  rise <- stair_rise(3000)

  run <- stair_horizontal_run(
    n_rises = rise$n_rises,
    going = 250,
    end = landing(depth = 1200, type = "end")
  )

  result <- stair_geometry(
    rise,
    run,
    last_step_is_landing = FALSE
  )

  expect_equal(
    tail(result$steps$type, 1),
    "arrival"
  )

  expect_equal(
    result$overall_run,
    run$flight_run
  )

})

test_that("landing depth increases overall geometry", {

  rise <- stair_rise(3000)

  run_no_end <- stair_horizontal_run(
    n_rises = rise$n_rises,
    going = 250
  )

  run_end <- stair_horizontal_run(
    n_rises = rise$n_rises,
    going = 250,
    end = landing(depth = 1000)
  )


  g1 <- stair_geometry(
    rise,
    run_no_end
  )

  g2 <- stair_geometry(
    rise,
    run_end,
    last_step_is_landing = TRUE
  )


  expect_gt(
    g2$overall_run,
    g1$overall_run
  )

})
