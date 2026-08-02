test_that("optimal_nrisers compute correctly", {
  
 results <- optimal_nrisers(40)
  
  testthat::expect_equal(results$n_steps, 2)
  testthat::expect_equal(results$step_height , 20)

  
 results2 <- optimal_nrisers(80)
  
  testthat::expect_equal(results$n_steps, 2)
  testthat::expect_equal(results$step_height, 20)

})
