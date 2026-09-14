#' Compute all possible stair solutions
#'
#' Main function of the package. Generates all feasible stair geometries
#' matching the specified constraints without selecting a preferred solution.
#'
#' For each valid number of steps, possible tread values are generated and
#' complete stair geometries are computed. All solutions are returned in a
#' single data frame, with geometry stored as a list-column.
#'
#' @param total_height `numeric` - Total vertical height to climb (cm).
#' @param max_horizontal_run `numeric` - Maximum available horizontal length (cm).
#' @param rise_min `numeric` - Minimum acceptable step height (cm). Default: 16.
#' @param rise_max `numeric` - Maximum acceptable step height (cm). Default: 20.
#' @param rise_target `numeric` - Target step height used to rank solutions (cm). Default: 16.
#' @param blondel_target `numeric` - Target value for Blondel's formula \code{2h + g}.
#'   Default: 63 cm.
#' @param show_invalid_solutions `logical` - If `TRUE`, returns all generated
#'   solutions, including solutions that do not satisfy the constraints.
#'   Default: `FALSE`.
#' @param check_stair_rules `logical` - If `TRUE`, returns additional columns relating to legal compliance and compliance with academic standards.
#' @inheritParams add_stair_surface_geometry
#' @return A `data.frame` containing one row per generated solution.
#' Geometry is stored in the `geometry` list-column.
#' @examples
#' sol <- solve_stairs(total_height = 160, max_horizontal_run = 150)
#' # default is a concrete floor with no nosing
#' sol
#' 
#' plot(sol$geometry[[1]])
#' 
#' # wood stair
#' sol2 <- solve_stairs(total_height = 160, max_horizontal_run = 230, tread_thickness = 4, nosing = 4)
#' #' # Filter out solution with a landing 
#' sol2 <- subset(sol2, has_landing)
#' plot_stair(sol2$geometry[[1]])
#' 
#' # Or get all the solutions, even if state-of-the-art will not be respected
#'  sol3 <- solve_stairs(160, 150, show_invalid_solutions = TRUE)
#' 
#' # Filter out valid solution
#' subset(sol3, is_valid)
#' @export
solve_stairs <- function(total_height,
                         max_horizontal_run,
                         nosing = 0,
                         rise_min = 16,
                         rise_max = 20,
                         rise_target = 16,
                         blondel_target = 63, positive_nosing_direction = TRUE,
    tread_thickness = 0,
    riser_thickness = 0,
                         show_invalid_solutions = FALSE
                        , check_stair_rules = FALSE) {

  candidats <- optimal_nrisers(total_height, rise_min, rise_max, rise_target)
  solutions <- build_solutions_table(candidats, max_horizontal_run, blondel_target)

  if(nrow(solutions) == 0 | all(!solutions$is_valid)) warning("No possibility of a comfortable staircase solution")


  # in order to sort the table : all possible solution first, then sorted by blondel law and - for equally case - sorted as a diff to a theoritical value 
  solutions <- solutions[order(solutions$is_valid, solutions$blondel_target_deviation , solutions$rise_target_deviation , decreasing = c(TRUE, FALSE, FALSE)), ]

  if(!show_invalid_solutions){solutions <- solutions[solutions$is_valid == TRUE, ]}

  # rank is raw number
  solutions$rank <- seq_len(nrow(solutions))


  solutions$geometry <- lapply(solutions$geometry, add_stair_surface_geometry, nosing = nosing, positive_nosing_direction = positive_nosing_direction, tread_thickness = tread_thickness, riser_thickness = riser_thickness)

  if(check_stair_rules) {solutions <- check_stair_rules(solutions)}

  attr(solutions, "scenarios_n_steps") <- candidats

return( solutions = solutions ) 

}
  