test_that("optimal_nrisers compute correctly", {
  
 results <- optimal_nrisers(40)
  
  testthat::expect_equal(results$n_risers, 2)
  testthat::expect_equal(results$rise , 20)

  
 results2 <- optimal_nrisers(80)
  
  testthat::expect_equal(results$n_risers, 2)
  testthat::expect_equal(results$rise, 20)


  result_neg <- optimal_nrisers(total_height = - 40)
  testthat::expect_equal(result_neg$n_risers, 2)
  testthat::expect_equal(result_neg$rise, 20)
})


test_that("optimal_nrisers deal with impossible stairs", {
  testthat::expect_error( result_impossible <- optimal_nrisers(total_height =  40, rise_target =  53, rise_min = 51, rise_max = 60) )
})

test_that("optimal_nrisers deal with incoherent values", {
 # rise_min and max incoherent, i.e. rise_min sup. to rise_max
 testthat::expect_error(  result_neg <- optimal_nrisers(total_height = - 40, rise_min = 2, rise_max = 1) )
  
  #rise_min : 0
 testthat::expect_error(  result_neg <- optimal_nrisers(total_height = - 40, rise_min = 0, rise_max = 1) ) 
  # rise_max : 0
  testthat::expect_error(  result_neg <- optimal_nrisers(total_height = - 40, rise_min = 10, rise_max = 0) ) 
  
  # warning when rise_target is above rise_max 
 testthat::expect_warning(  result_null <- optimal_nrisers(total_height = - 40, rise_target = 30,  rise_max = 28) )

  # warning when rise_target is inferior to rise_min 
 testthat::expect_warning(  result_null <- optimal_nrisers(total_height = - 40, rise_target = 17,  rise_min = 18) )

})