#' Solve a complete stair design problem
#'
#' Finds possible stair configurations from a total height and an available
#' horizontal space. The function calculates:
#'
#' \itemize{
#'   \item an ideal stair using Blondel's comfort rule;
#'   \item a buildable stair fitting the available length.
#' }
#'
#' The function works internally in millimetres.
#'
#' @param height Numeric. Total vertical height to overcome, in millimetres.
#' @param max_run Numeric. Maximum available horizontal development,
#'   in millimetres.
#' @param target_rise Numeric. Preferred rise height in millimetres.
#'   Default is 160 mm.
#' @param blondel Numeric. Target Blondel value:
#'   \eqn{2 \times rise + going}.
#'   Default is 630 mm.
#' @param min_rise Numeric. Minimum allowed rise height.
#'   Default is 160 mm.
#' @param max_rise Numeric. Maximum allowed rise height.
#'   Default is 200 mm.
#'
#' @return An object of class \code{"stair_solution"} containing:
#' \describe{
#'   \item{rise}{Vertical calculation object of class
#'   \code{"stair_rise"}.}
#'   \item{optimal}{Theoretical stair configuration based on Blondel.}
#'   \item{build}{Recommended stair configuration fitting the available
#'   space.}
#'   \item{candidates}{All valid tested configurations.}
#' }
#'
#' @details
#' The function first determines possible rise heights. For each solution,
#' it calculates:
#'
#' \deqn{going = Blondel - 2 \times rise}
#'
#' Then it compares this theoretical solution with the available horizontal
#' space.
#'
#' If the ideal stair is too long, the going is reduced so that the stair
#' fits the available space. The resulting Blondel value is returned.
#'
#' @examples
#' \dontrun{
#'
#' stair <- stair_solve(
#'   height = 850,
#'   max_run = 1030
#' )
#'
#' stair$build
#'
#' }
#'
#' @export
stair_solve <- function(
    height,
    max_run,
    target_rise = 160,
    blondel = 630,
    min_rise = 160,
    max_rise = 200
) {
  
  
  # ------------------------------------------------------------
  # Basic checks
  # ------------------------------------------------------------
  
  if (height <= 0)
    stop("height must be positive")
  
  if (max_run <= 0)
    stop("max_run must be positive")
  
  
  # ------------------------------------------------------------
  # Calculate vertical subdivision
  # ------------------------------------------------------------
  
  rise <- stair_rise(
    height = height,
    target_rise = target_rise,
    min_rise = min_rise,
    max_rise = max_rise
  )
  
  
  h <- rise$rise
  n <- rise$n_rises
  
  
  # Number of walking surfaces
  # A staircase with n rises has normally n-1 treads
  n_treads <- n - 1
  
  
  if (n_treads < 1)
    stop("Not enough rises to create a stair")
  
  
  # ------------------------------------------------------------
  # Ideal Blondel solution
  # ------------------------------------------------------------
  
  ideal_going <- blondel - 2 * h
  
  ideal_run <- n_treads * ideal_going
  
  
  optimal <- list(
    
    n_rises = n,
    
    rise = h,
    
    n_treads = n_treads,
    
    going = ideal_going,
    
    flight_run = ideal_run,
    
    blondel = 2*h + ideal_going,
    
    fits = ideal_run <= max_run
  )
  
  
  # ------------------------------------------------------------
  # Buildable solution
  #
  # The available space limits the going.
  # We use all available length unless another constraint
  # is introduced later.
  # ------------------------------------------------------------
  
  build_going <- max_run / n_treads
  
  build_run <- stair_run(
    n_rises = n,
    going = build_going
  )
  
  
  build <- list(
    
    run = build_run,
    
    n_rises = n,
    
    rise = h,
    
    n_treads = n_treads,
    
    going = build_going,
    
    flight_run = n_treads * build_going,
    
    blondel = 2*h + build_going,
    
    fits = TRUE
  )
  
  
  # ------------------------------------------------------------
  # Return complete calculation object
  # ------------------------------------------------------------
  
  result <- list(
    
    height = height,
    
    max_run = max_run,
    
    rise = rise,
    
    optimal = optimal,
    
    build = build
    
  )
  
  
  class(result) <- "stair_solution"
  
  
  result
}