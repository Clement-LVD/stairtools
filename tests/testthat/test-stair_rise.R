test_that("stair_rise returns a stair_rise object", {

  result <- stair_rise(3000)

  expect_s3_class(result, "stair_rise")
  expect_true(result$found_solution)

})


test_that("stair_rise returns expected fields", {

  result <- stair_rise(3000)

  expect_named(
    result,
    c(
      "height",
      "n_rises",
      "rise",
      "score",
      "candidates",
      "target_rise",
      "min_rise",
      "max_rise",
      "units",
      "found_solution"
    )
  )

})


test_that("stair_rise preserves input height", {

  result <- stair_rise(3200)

  expect_equal(result$height, 3200)
  expect_equal(result$units, "mm")

})


test_that("computed rise respects constraints", {

  result <- stair_rise(
    height = 3200,
    min_rise = 150,
    max_rise = 200
  )

  expect_gte(result$rise, 150)
  expect_lte(result$rise, 200)

})


test_that("computed rise matches height divided by number of rises", {

  height <- 3200

  result <- stair_rise(height)

  expect_equal(
    result$rise,
    height / result$n_rises
  )

})


test_that("chosen rise minimizes distance from target", {

  result <- stair_rise(
    height = 3000,
    target_rise = 170,
    min_rise = 150,
    max_rise = 200
  )

  expect_equal(
    result$score,
    min(result$candidates$score)
  )

})


test_that("candidates are sorted by score", {

  result <- stair_rise(3000)

  expect_true(
    all(diff(result$candidates$score) >= 0)
  )

})
test_that("no solution returns a valid stair_rise object", {

  result <- stair_rise(
    height = 1000,
    target_rise = 400,
    min_rise = 400,
    max_rise = 450
  )

  expect_s3_class(result, "stair_rise")

  expect_false(result$found_solution)

  expect_true(is.na(result$rise))

  expect_true(is.na(result$n_rises))

})

test_that("invalid height gives error", {

  expect_error(
    stair_rise(0),
    "height must be positive"
  )

  expect_error(
    stair_rise(-100),
    "height must be positive"
  )

})


test_that("invalid numeric inputs give error", {

  expect_error(
    stair_rise("3000"),
    "height must be a finite numeric value"
  )

  expect_error(
    stair_rise(3000, target_rise = NA),
    "target_rise must be a finite numeric value"
  )

  expect_error(
    stair_rise(3000, min_rise = Inf),
    "min_rise must be a finite numeric value"
  )

})


test_that("min_rise cannot exceed max_rise", {

  expect_error(
    stair_rise(
      height = 3000,
      min_rise = 220,
      max_rise = 160
    ),
    "min_rise must be lower than max_rise"
  )

})


test_that("warning is generated when target rise is outside limits", {

  expect_warning(
    stair_rise(
      height = 3000,
      target_rise = 250,
      min_rise = 150,
      max_rise = 200
    ),
    "target_rise"
  )

})


test_that("known stair example gives expected result", {

  result <- stair_rise(
    height = 3000,
    target_rise = 160
  )

  expect_equal(result$n_rises, 18)
  expect_equal(result$rise, 3000 / 18)

})

test_that("chosen rise is the closest valid solution", {

  result <- stair_rise(
    height = 3000,
    target_rise = 160
  )

  valid <- result$candidates

  expect_equal(
    result$rise,
    valid$rise[which.min(valid$score)]
  )

})

# print ad summary method :

test_that("print method works", {

  result <- stair_rise(3000)

  output <- capture.output(
    print(result)
  )

  expect_true(
    any(grepl("Stair rise calculation", output))
  )

  expect_true(
    any(grepl("Number of rises", output))
  )

})



test_that("summary method returns expected information", {

  result <- stair_rise(3000)

  s <- summary(result)

  expect_named(
    s,
    c(
      "height",
      "rises",
      "rise",
      "found_solution"
    )
  )

})
test_that("print method handles no solution", {

  result <- stair_rise(
    height = 1000,
    target_rise = 400,
    min_rise = 400,
    max_rise = 450
  )

  output <- capture.output(
    print(result)
  )

  expect_true(
    any(grepl("No valid stair solution found", output))
  )

})
