#' Select the best stair solution
#'
#' Selects the best valid solution from a table of stair solutions.
#' Only rows where \code{is_valid} is \code{TRUE} are considered.
#' Among these, the solution with the lowest \code{rank} is returned.
#'
#' The corresponding stair geometry can be accessed directly from the
#' returned row via \code{$geometry[[1]]}.
#'
#' @param solutions A \code{stair_solutions} object returned by
#'   \code{\link{build_solutions_table}} (or
#'   \code{solve_stairs(...)\$solutions}).
#'
#' @return Return a one-row \code{data.frame} (class
#'   \code{stair_solutions}) corresponding to the highest-ranked valid
#'   solution. Returns \code{NULL} if no valid solution exists.
#'
#' @examples
#' sol <- solve_stairs(200, 160)
#' best <- best_solution(sol)
#' plot(best$geometry[[1]])
#'
#' @export
best_solution <- function(solutions) {

  feasables <- solutions[solutions$is_valid, ]

  if (!any(solutions$is_valid)) {
    warning(
  "No valid solution found. All candidate solutions either exceed the ",
  "available horizontal run or fail the comfort criteria.\n",
  "==> Try widening the allowed rise range, increasing ",
  "'max_horizontal_run', or adjusting 'blondel_target'."
)
    
    return(NULL)
  }

  #we have a scoring var' to this point
  ordr <- order(feasables$rank)
  
  best_solution <- feasables[ordr[1], ]

  if(best_solution$blondel < 60 | best_solution$blondel > 64) 
    warning(
  call. = FALSE,
  "The best solution does not produce a comfortable staircase ",
  "(Blondel value outside the recommended 60 <-> 64 cm range).\n",
  "==> Consider increasing 'max_horizontal_run'."
)

  return(best_solution)
}
