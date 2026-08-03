#' Build the complete geometry of a stair
#'
#' Computes the geometry of each riser by determining its horizontal
#' position (the cumulative width of the preceding goings) together with
#' its bottom and top elevations.
#'
#' Two going configurations are supported:
#' \itemize{
#'   \item A vector of length \code{n_steps - 1}, corresponding to a
#'     conventional stair where the last riser reaches the landing
#'     directly, with no going beyond it.
#'   \item A vector of length \code{n_steps}, corresponding to a stair
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
#' @param n_steps Number of risers.
#' @param step_height Uniform riser height.
#' @param goings Numeric vector of going lengths, with length
#'   \code{n_steps - 1} (standard stair) or \code{n_steps}
#'   (including a landing going).
#'
#' @return Return a `data.frame` with one row per riser and the following columns:
#'   \code{step}, \code{x_riser}, \code{y_bottom}, \code{y_top},
#'   \code{going}, \code{x_going_end}, and \code{going_type}.
#'
#' @examples
#' geometry <- build_geometry(n_steps = 5, step_height = 17.33, goings = rep(28.33, 4) )
#' geometry
#' plot(geometry)
#'
#' @export
build_geometry <- function(n_steps, step_height, goings) {

  n_goings   <- length(goings)
  n_without_extension <- n_steps - 1

  if (!(n_goings   %in% c(n_without_extension, n_steps))) {
  stop(sprintf(
    "length(goings) must be equal to n_steps - 1 (%d, standard stair) or n_steps (%d, with an extended landing going).",
    n_without_extension, n_steps
  ))
}

  if (n_goings   == n_without_extension) { goings <- c(goings, NA_real_)   }
  # from here : girons et going_types sont de longueur n_steps

  cumul_going <- ifelse(is.na(goings), 0, goings)
  x_riser  <- c(0, cumsum(cumul_going))[seq_len(n_steps)]
  y_bottom  <- (0:(n_steps - 1)) * step_height
   y_top  <- (1:n_steps) * step_height

  geometry <- data.frame(
    step           = seq_len(n_steps),
    x_riser        = x_riser ,
    y_bottom       = y_bottom,
    y_top          =  y_top ,
    going          = goings,
    x_going_end    = x_riser  + goings, 
    stringsAsFactors = FALSE
  )

  # code en frenchi : 
  # geometrie <- data.frame( num_steps = seq_len(n_steps), x_contremarche = x_contremarche, y_bas = y_bas, y_haut = y_haut, giron = goings, x_fin_giron = x_contremarche + goings, type_giron = going_types, stringsAsFactors = FALSE )

  # TODO il faudrait mettre des NA pour la derniere contramarche !
  #geometry <- data.frame(
 # step        = seq_len(n_steps),
 # x_riser     = x_riser,
 # y_bottom    = y_bottom,
  #y_top       = y_top,
  #going       = c(goings, NA)[seq_len(n_steps)],
 # x_going_end = c(x_riser + goings, NA)[seq_len(n_steps)],
  #going_type  = c(going_types, NA)[seq_len(n_steps)],
  #stringsAsFactors = FALSE)

  # Classe S3 dédiée : permet d'appeler plot(geometrie) directement (voir
  # plot.escalier_geometrie() dans plot_escalier.R) plutôt que d'obtenir le
  # pairs-plot par défaut de plot.data.frame().
  class(geometry) <- c("stair_geometry", class(geometry))
  geometry
}

