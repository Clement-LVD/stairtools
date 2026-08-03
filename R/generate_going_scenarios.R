#' Generate possible going scenarios for a given number of steps
#'
#' For a given \code{n_steps} and its Blondel \code{going}, systematically
#' generates 5 going scenarios without favoring any of them (the choice is
#' made later, by comparing \code{blondel_target_deviation} and \code{horizontal_run}
#' across scenarios):
#'
#' \describe{
#'   \item{no_landing_blondel}{Standard (Blondel) goings, no landing step.
#'     The last riser lands directly on the landing.}
#'   \item{no_landing_uniform}{A uniform going = \code{max_horizontal_run / n_goings},
#'     ignoring Blondel, to fill the whole space with no landing step.}
#'   \item{landing_standard}{Standard goings + a landing step (after the last
#'     riser, at landing level), also at the standard going: leftover space
#'     may remain.}
#'   \item{landing_max}{Standard goings + a landing step that absorbs all
#'     remaining space (potentially very large going: filling an opening,
#'     giant landing step in front of a door, etc.).}
#'   \item{landing_uniform}{A uniform going = \code{max_horizontal_run / n_steps},
#'     applied to all steps including the landing step.}
#' }
#'
#' In every "with landing" scenario, the landing step is the last one,
#' positioned after the last riser, at the same height as the finished floor
#' on arrival — never followed by a riser.
#'
#' \code{blondel_target_deviation} only covers goings of type "standard": the landing
#' step's going is excluded from the calculation, since the foot is already
#' at finished floor level there (its value doesn't affect the comfort of
#' the climb).
#'
#' If the space doesn't allow a scenario (zero or negative landing going), it
#' is still returned, with \code{landing_impossible = TRUE} and/or
#' \code{horizontal_run_exceeded = TRUE}: nothing is hidden, everything is left for
#' later comparison.
#'
#' @param n_steps Number of risers.
#' @param max_horizontal_run Available horizontal distance (cm).
#' @param going Going from \code{\link{blondel_going}} (cm).
#'
#' @return A named list of 5 scenarios (empty list if \code{n_steps <= 1}).
#'   Each scenario contains: \code{goings}, \code{going_type},
#'   \code{horizontal_run}, \code{blondel_target_deviation} (mean absolute gap to the
#'   standard going, standard goings only), \code{has_landing}, and
#'   depending on the case \code{horizontal_run_exceeded} and/or
#'   \code{landing_impossible}.
#'
#' @examples
#' going <- blondel_going(16.25)  # 30.5
#' scenarios <- generate_going_scenarios(n_steps = 16, max_horizontal_run = 450,
#'                                       going = going)
#' names(scenarios)
#' scenarios$landing_max$blondel_target_deviation  # 0: the giant landing step doesn't count
#'
#' @export
generate_going_scenarios <- function(n_steps, max_horizontal_run, going) {

  n_goings <- n_steps - 1
  if (n_goings <= 0) return(list())

  # Mean absolute gap to Blondel, standard goings only (landing excluded)
  blondel_target_deviation <- function(g, type) mean(abs(g[type == "standard"] - going))

  # Assembles one scenario, filling in blondel_target_deviation and any extra fields
  scenario <- function(goings, going_type, horizontal_run, ...) {
    c(list(goings = goings, going_type = going_type, horizontal_run = horizontal_run,
           blondel_target_deviation = blondel_target_deviation(goings, going_type)), list(...))
  }

  std_goings   <- rep(going, n_goings)
  std_types    <- rep("standard", n_goings)
  blondel_dist <- sum(std_goings)
  landing_ext  <- max_horizontal_run - blondel_dist

  list(
    no_landing_blondel = scenario(
      std_goings, std_types, blondel_dist,
      horizontal_run_exceeded = blondel_dist > max_horizontal_run, has_landing = FALSE),

    no_landing_uniform = scenario(
      rep(max_horizontal_run / n_goings, n_goings), std_types, max_horizontal_run,
      horizontal_run_exceeded = FALSE, has_landing = FALSE),

    landing_standard = scenario(
      c(std_goings, going), c(std_types, "landing"), blondel_dist + going,
      horizontal_run_exceeded = (blondel_dist + going) > max_horizontal_run, has_landing = TRUE),

    landing_max = scenario(
      c(std_goings, landing_ext), c(std_types, "landing"), blondel_dist + max(landing_ext, 0),
      landing_impossible = landing_ext <= 0, has_landing = TRUE),

    landing_uniform = scenario(
      rep(max_horizontal_run / n_steps, n_steps), c(std_types, "landing"), max_horizontal_run,
      horizontal_run_exceeded = FALSE, has_landing = TRUE)
  )
}