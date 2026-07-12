test_that("stair_horizontal_run returns a stair_run object", {

  result <- stair_horizontal_run(
    n_rises = 10,
    going = 300
  )

  expect_s3_class(result, "stair_run")

})


test_that("stair_horizontal_run returns expected fields", {

  result <- stair_horizontal_run(
    n_rises = 10,
    going = 300
  )

  expect_named(
    result,
    c(
      "n_rises",
      "n_treads",
      "going",
      "flight_run",
      "overall_run",
      "start",
      "end",
      "units"
    )
  )

})


test_that("number of treads is one less than rises", {

  result <- stair_horizontal_run(
    n_rises = 10,
    going = 300
  )

  expect_equal(
    result$n_treads,
    9
  )

})


test_that("flight run is calculated correctly", {

  result <- stair_horizontal_run(
    n_rises = 10,
    going = 300
  )

  expect_equal(
    result$flight_run,
    9 * 300
  )

})


test_that("overall run includes landings", {

  result <- stair_horizontal_run(
    n_rises = 10,
    going = 300,
    start = landing(depth = 100),
    end = landing(depth = 150)
  )

  expect_equal(
    result$overall_run,
    100 + 9 * 300 + 150
  )

})


test_that("default landings have no additional length", {

  result <- stair_horizontal_run(
    n_rises = 10,
    going = 300
  )

  expect_equal(
    result$overall_run,
    result$flight_run
  )

})


test_that("landings are stored in the result", {

  start <- landing(
    depth = 200,
    type = "start"
  )

  end <- landing(
    depth = 250,
    type = "end"
  )

  result <- stair_horizontal_run(
    n_rises = 10,
    going = 300,
    start = start,
    end = end
  )

  expect_identical(
    result$start,
    start
  )

  expect_identical(
    result$end,
    end
  )

})


test_that("n_rises must be at least two", {

  expect_error(
    stair_horizontal_run(
      n_rises = 1,
      going = 300
    ),
    "integer greater than or equal to 2"
  )

})


test_that("n_rises must be an integer", {

  expect_error(
    stair_horizontal_run(
      n_rises = 2.5,
      going = 300
    ),
    "integer"
  )

})


test_that("going must be positive", {

  expect_error(
    stair_horizontal_run(
      n_rises = 10,
      going = 0
    ),
    "going must be positive"
  )

  expect_error(
    stair_horizontal_run(
      n_rises = 10,
      going = -300
    ),
    "going must be positive"
  )

})


test_that("invalid start landing gives error", {

  expect_error(
    stair_horizontal_run(
      n_rises = 10,
      going = 300,
      start = list(depth = 100)
    ),
    "start must be a landing"
  )

})


test_that("invalid end landing gives error", {

  expect_error(
    stair_horizontal_run(
      n_rises = 10,
      going = 300,
      end = list(depth = 100)
    ),
    "end must be a landing"
  )

})


test_that("invalid numeric inputs give error", {

  expect_error(
    stair_horizontal_run(
      n_rises = "10",
      going = 300
    ),
    "n_rises"
  )

  expect_error(
    stair_horizontal_run(
      n_rises = 10,
      going = "300"
    ),
    "going"
  )

})


test_that("print method works", {

  result <- stair_horizontal_run(
    n_rises = 10,
    going = 300
  )

  output <- capture.output(
    print(result)
  )

  expect_true(
    any(grepl("Stair run calculation", output))
  )

  expect_true(
    any(grepl("Number of rises", output))
  )

})

# test real stair :
test_that("typical stair run calculation is coherent", {

  result <- stair_horizontal_run(
    n_rises = 18,
    going = 250
  )

  expect_equal(result$n_treads, 17)
  expect_equal(result$flight_run, 4250)

})
