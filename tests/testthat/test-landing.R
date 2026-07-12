test_that("landing creates a landing object", {
  expect_s3_class(landing(), "landing")
})


test_that("landing default depth is zero", {
  expect_equal(
    landing()$depth,
    0
  )
})


test_that("landing stores depth and type", {

  result <- landing(
    depth = 1200,
    type = "start"
  )

  expect_equal(result$depth, 1200)
  expect_equal(result$type, "start")

})


test_that("landing stores units", {

  expect_equal(
    landing()$units,
    "mm"
  )

})


test_that("landing rejects negative depth", {

  expect_error(
    landing(-100),
    "depth must be positive"
  )

})


test_that("landing rejects invalid depth values", {

  expect_error(landing("100"))
  expect_error(landing(NA))
  expect_error(landing(Inf))

})


test_that("landing validates type", {

  expect_error(
    landing(type = "invalid")
  )

})


test_that("landing accepts all valid types", {

  expect_no_error(landing(type = "none"))
  expect_no_error(landing(type = "start"))
  expect_no_error(landing(type = "end"))
  expect_no_error(landing(type = "intermediate"))

})