#' Determine feasible numbers of risers (vertical element between steps) for a given total height
#'
#' Computes all feasible numbers of steps for a specified total height,
#' according to the minimum and maximum allowable riser heights.
#'
#' For each feasible solution, the corresponding riser height and its
#' absolute deviation from the target riser height are computed.
#' Solutions are returned in ascending order of deviation, so the first
#' row corresponds to the riser height closest to the target.
#'
#' @param total_height `numeric` - Total vertical height to climb (cm).
#' @param rise_min `numeric` - Minimum acceptable riser height (cm).
#'   Default: 16.
#' @param rise_max `numeric` - Maximum acceptable riser height (cm).
#'   Default: 20.
#' @param rise_target `numeric` - Target riser height used to rank
#'   solutions (cm). Default: 16.
#'
#' @return Return a `data.frame` with one row per feasible solution.
#' The returned data frame contains the following columns:
#' \describe{
#'   \item{n_risers}{Number of risers.}
#'   \item{rise}{Computed riser height (cm).}
#'   \item{rise_target_deviation}{Absolute deviation from the target riser height (cm).}
#' }
#'
#' Rows are ordered by increasing `rise_target_deviation`.
#'
#' @examples
#' optimal_nrisers(total_height = 260)
#'
#' @export
optimal_nrisers <- function(total_height,
                                    rise_min = 16,
                                    rise_max = 20,
                                    rise_target = 16) {
  
  total_height <- abs(total_height)
  rise_min <- abs(rise_min)
  rise_max <- abs(rise_max)
  
  if (rise_min <= 0 || rise_max <= 0 || rise_min >= rise_max) stop("rise_min must be positive and smaller than rise_max.")
  if (rise_target < rise_min || rise_target > rise_max) { warning("rise_target is outside the [rise_min, rise_max] interval.") }


  n_min <- ceiling(total_height / rise_max)
  n_max <- floor(total_height / rise_min)

if (n_min > n_max) {
    stop(sprintf( paste( "No feasible solution:",
        "cannot climb %.1f cm with riser heights between %.1f and %.1f cm.",
        "Consider widening the rise_min/rise_max interval." )
                , total_height, rise_min, rise_max  ))
                    }

  n_candidates <- n_min:n_max
  rise <- total_height / n_candidates
  deviation <- abs(rise - rise_target)

  res <- data.frame(
    n_risers = n_candidates,
    rise = rise,
    rise_target_deviation = deviation
  )

  res[order(res$rise_target_deviation), , drop = FALSE]
}
