test_that("check_stair_rules returns expected columns", {

  x <- data.frame(
    step_rise = c(15, 17, 19),
    going = c(30, 28, 25),
    blondel = c(60, 62, 63)
  )

  result <- check_stair_rules(x)

  expect_true(all(stair_rules$id %in% names(result)))
  expect_true(all(c("n_rules_ok", "rate_rules_ok") %in% names(result)))
})


test_that("check_stair_rules computes rule scores", {

  x <- data.frame(
    step_rise = c(15, 17, 19),
    going = c(30, 28, 25),
    blondel = c(60, 62, 63)
  )

  result <- check_stair_rules(x)

  expect_equal(
    result$n_rules_ok,
    rowSums(result[stair_rules$id] == TRUE, na.rm = TRUE)
  )

  expect_equal(
    result$rate_rules_ok,
    result$n_rules_ok / nrow(stair_rules)
  )
})


test_that("check_stair_rules can select a single rule", {

  x <- data.frame(
    step_rise = c(15, 17, 19),
    going = c(30, 28, 25),
    blondel = c(60, 62, 63)
  )

  rule <- stair_rules$id[1]
  result <- check_stair_rules(x, rule)

  expect_true(rule %in% names(result))
  expect_equal(result$n_rules_ok, as.integer(result[[rule]]))
})


test_that("check_stair_rules rejects unknown rules", {

  x <- data.frame(
    step_rise = 17,
    going = 28,
    blondel = 62
  )

  expect_error(
    check_stair_rules(x, "unknown_rule"),
    "Unknown rule"
  )
})