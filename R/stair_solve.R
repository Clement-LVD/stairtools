#' Solve stair geometry from height and available length
#'
#' Searches for stair solutions using Blondel's formula and available space.
#'
#' @param height Total height in mm.
#' @param max_run Maximum available horizontal length in mm.
#' @param target_rise Desired rise height.
#' @param blondel Target Blondel value.
#' @param min_rise Numeric. Minimum allowed rise height in millimetres.
#'   Default is 160 mm.
#' @param max_rise Numeric. Maximum allowed rise height in millimetres.
#'   Default is 200 mm.
#'
#' @return Object of class "stair_solution".
#' @examples
#' s <- stair_solve(height = 850,max_run = 1030)
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
  
  
  # Vertical search
  r <- stair_rise(
    height = height,
    target_rise = target_rise,
    min_rise = min_rise,
    max_rise = max_rise
  )
  
  
  h <- r$rise
  n <- r$n_rises
  n_treads <- n - 1
  
  
  if(n_treads < 1)
    stop("Not enough rises")
  
  
  # -----------------------------
  # 1) Ideal Blondel solution
  # -----------------------------
  
  ideal_going <-
    blondel - 2*h
  
  
  ideal_run <-
    ideal_going * n_treads
  
  
  ideal <- stair_run(
    n_rises = n,
    going = ideal_going
  )
  
  
  # -----------------------------
  # 2) Solution filling available space
  # -----------------------------
  
  available_going <-
    max_run / n_treads
  
  
  adapted <- stair_run(
    n_rises = n,
    going = available_going
  )
  
  
  # Calculate real Blondel values
  
  ideal_blondel <-
    2*h + ideal_going
  
  
  adapted_blondel <-
    2*h + available_going
  
  
  structure(
    list(
      
      rise = r,
      
      
      optimal = list(
        run = ideal,
        going = ideal_going,
        blondel = ideal_blondel,
        fits = ideal_run <= max_run
      ),
      
      
      max_space = list(
        run = adapted,
        going = available_going,
        blondel = adapted_blondel,
        fits = TRUE
      )
      
    ),
    class="stair_solution"
  )
}