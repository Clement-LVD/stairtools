test_that("optimal_nsteps compute correctly", {
  
 results <- optimal_nsteps(hauteur_a_franchir = 40)
  
  testthat::expect_equal(results$n_marches, 2)
  testthat::expect_equal(results$hauteur_marche, 20)

  
 results2 <- optimal_nsteps(hauteur_a_franchir = 80)
  
  testthat::expect_equal(results$n_marches, 2)
  testthat::expect_equal(results$hauteur_marche, 20)

})
