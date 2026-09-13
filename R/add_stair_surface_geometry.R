#' Add physical stair surface geometry
#'
#' Adds physical tread and riser coordinates to a theoretical stair
#' geometry. Theoretical dimensions such as `rise` and `going` are not
#' modified.
#'
#' The nosing determines the physical extent of each tread. For a
#' positive `nosing_direction`, treads extend beyond `x_going_end`.
#' For a negative `nosing_direction`, treads extend before their
#' theoretical starting position.
#'
#' The riser position is determined from the theoretical step origin
#' and the nosing direction. For a positive `nosing_direction`, the
#' riser is shifted by the nosing length toward positive x. For a
#' negative `nosing_direction`, the riser remains at `x_step_start`.
#'
#' @param geometry A stair geometry data frame containing at least
#'   `x_step_start`, `x_going_end`, and `has_tread`.
#' @param nosing Numeric length of the nosing extension. Must be
#'   non-negative and use the same units as `geometry`.
#' @param nosing_direction Direction of the physical tread extension.
#'   Either `"positive"` or `"negative"`.
#'
#' @return The input geometry with three additional columns:
#'   \code{x_tread_start}, the horizontal coordinate of the physical
#'   beginning of the tread surface;
#'   \code{x_tread_end}, the horizontal coordinate of the physical end
#'   of the tread surface, including the nosing extension; and
#'   \code{x_riser}, the horizontal coordinate of the front face of
#'   the corresponding riser.
#'
#' @examples
#' geometry <- build_geometry(
#'   n_risers = 5,
#'   step_height = 17.33,
#'   goings = rep(28.33, 4)
#' )
#'
#' geometry <- add_stair_surface_geometry(
#'   geometry,
#'   nosing = 4,
#'   nosing_direction = "positive"
#' )
#'
#' geometry[, c(
#'   "step", "x_step_start", "x_tread_start",
#'   "x_tread_end", "x_riser"
#' )]
#'
#' geometry <- add_stair_surface_geometry(
#'   build_geometry(
#'     n_risers = 5,
#'     step_height = 17.33,
#'     goings = rep(28.33, 4)
#'   ),
#'   nosing = 4,
#'   nosing_direction = "negative"
#' )
#'
#' geometry[, c(
#'   "step", "x_step_start", "x_tread_start",
#'   "x_tread_end", "x_riser"
#' )]
#' @export
add_stair_surface_geometry <- function(
    geometry,
    nosing,
    nosing_direction = c("positive", "negative")) {

  nosing_direction <- match.arg(nosing_direction)

  i <- which(geometry$has_tread)

  geometry$x_tread_start <- geometry$x_step_start
  geometry$x_tread_end <- geometry$x_going_end

  if (nosing_direction == "positive") {

    # The nosing extends the tread toward positive x.
    i_extended <- head(i, -1)

    geometry$x_tread_end[i_extended] <-  geometry$x_tread_end[i_extended] + nosing

    # The riser follows the physical front edge of the tread.
    geometry$x_riser <-   geometry$x_step_start + nosing

  }  
  
  if (nosing_direction == "negative") { 

    # The nosing extends the tread toward negative x.
    geometry$x_tread_start[i] <-   geometry$x_tread_start[i] - nosing

    # The riser remains at the theoretical step origin since nosing extending it
    geometry$x_riser <-  geometry$x_step_start
  }

  geometry
}