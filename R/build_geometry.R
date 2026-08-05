#' Build the complete geometry of a stair
#'
#' Computes the geometry of each riser by determining its horizontal
#' position (the cumulative width of the preceding goings) together with
#' its bottom and top elevations.
#'
#' Two going configurations are supported:
#' \itemize{
#'   \item A vector of length \code{n_risers - 1}, corresponding to a
#'     conventional stair where the last riser reaches the landing
#'     directly, with no going beyond it.
#'   \item A vector of length \code{n_risers}, corresponding to a stair
#'     with an additional landing going after the last riser, at the
#'     same elevation as the destination landing.
#' }
#'
#' The returned geometry is intended to be plotted directly using
#' \code{segments()} in base R:
#' \itemize{
#'   \item Riser \emph{i} (vertical): from
#'     \code{(x_riser, y_bottom)} to \code{(x_riser, y_top)}.
#'   \item Going \emph{i} (horizontal), when present: from
#'     \code{(x_riser, y_top)} to \code{(x_going_end, y_top)}. 
#' }
#'
#' @param n_risers Number of risers.
#' @param step_height Uniform riser height.
#' @param goings Numeric vector of going lengths, with length
#'   \code{n_risers - 1} (standard stair) or \code{n_risers}
#'   (including a landing going).
#'
#' @return Return a `data.frame` with one row per riser and the following columns:
#'   \code{step}, \code{x_riser}, \code{y_bottom}, \code{y_top},
#'   \code{going}, \code{x_going_end}, and \code{going_type}.
#'
#' @examples
#' geometry <- build_geometry(n_risers = 5, step_height = 17.33, goings = rep(28.33, 4) )
#' geometry
#' plot(geometry)
#'
#' @export
build_geometry <- function(n_risers, step_height, goings) {

  n_goings   <- length(goings)
  n_without_extension <- n_risers - 1

  if (!(n_goings   %in% c(n_without_extension, n_risers))) {
  stop(sprintf(
    "length(goings) must be equal to n_risers - 1 (%d, standard stair) or n_risers (%d, with an extended landing going).",
    n_without_extension, n_risers
  ))
}

  if (n_goings   == n_without_extension) { goings <- c(goings, NA_real_)   }
  # if a going is missing : the step don't exist (the arrival floor level is the last step)
  has_tread <- !is.na(goings)

  cumul_going <- goings
  cumul_going[is.na(cumul_going)] <- 0 # equiv to : cumul_going <- ifelse(is.na(goings), 0, goings)

   x_riser <- c(0, cumsum(cumul_going))[seq_len(n_risers)] 

  geometry <- data.frame(
    step           = seq_len(n_risers),
    x_riser        = x_riser,
    y_bottom       = (0:(n_risers - 1)) * step_height,
    y_top          =  (1:n_risers) * step_height ,
    rise         = rep(step_height, n_risers),
    going          = goings,
    x_going_end    = x_riser  + goings, 
    has_tread    = has_tread,
    stringsAsFactors = FALSE
  )

  class(geometry) <- c("stair_geometry", class(geometry))
  geometry
}

