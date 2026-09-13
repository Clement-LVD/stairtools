#' Add physical stair surface geometry
#'
#' Adds physical tread and riser coordinates to a theoretical stair
#' geometry. Theoretical dimensions such as `rise` and `going` are not
#' modified.
#'
#' The nosing determines the physical extent of each tread. When
#' `positive_nosing_direction` is `TRUE`, treads are extended toward
#' positive x, except for the last tread. When it is `FALSE`, all
#' treads are extended toward negative x.
#'
#' The riser position is determined from the theoretical step origin.
#' When `positive_nosing_direction` is `TRUE`, intermediate risers are
#' shifted by the nosing length toward positive x, while the last riser
#' remains at `x_step_start`. When it is `FALSE`, all risers remain at
#' `x_step_start`.
#'
#' Tread and riser thicknesses define the physical geometry of the
#' corresponding elements. The bottom of the tread and the top
#' of the riser share the same vertical coordinate, `riser_top_y`.
#'
#' A concrete stair can be represented by setting `nosing`,
#' `tread_thickness`, and `riser_thickness` to zero.
#'
#' @param geometry `data.frame` - A stair geometry data frame containing at least
#'   `x_step_start`, `x_going_end`, `y_top`, `y_bottom`, and `has_tread`.
#' @param nosing `numeric` - length of the nosing extension. Must be
#'   non-negative and use the same units as `geometry`.
#' @param positive_nosing_direction `logical` - If `TRUE`, the nosing
#'   extends toward the positive x-axis. If `FALSE`, it extends toward
#'   the negative x-axis.
#' @param tread_thickness `numeric` - Tread thickness (cm). Defaults to `0`.
#' @param riser_thickness `numeric` - Riser thickness (cm). Defaults to `0`.
#'
#' @return The input geometry with additional physical surface
#'   coordinates and logical variable.
#'
#' @examples
#' geometry <- add_stair_surface_geometry(build_geometry(5, 17.33, rep(28.33, 4)), 4)
#' geometry
#'
#' geometry <- add_stair_surface_geometry(build_geometry(5, 17.33, rep(28.33, 4)), 4, FALSE, 4, 3)
#' geometry[, c("x_tread_start", "x_tread_end", "riser_top_y", "riser_bottom_y", "x_riser_end")]
#'
#' # A concrete stair: no nosing, zero tread and riser thickness.
#' geometry <- add_stair_surface_geometry(build_geometry(5, 17.33, rep(28.33, 4)), 0, TRUE, 0, 0)
#'str(geometry)
#' @export
add_stair_surface_geometry <- function(
    geometry,
    nosing,
    positive_nosing_direction = TRUE,
    tread_thickness = 0,
    riser_thickness = 0) {
  
  i <- which(geometry$has_tread)

  geometry$x_tread_start <- geometry$x_step_start
  geometry$x_tread_end <- geometry$x_going_end

  geometry$has_nosing <- FALSE #false by default

  # Finalize the horizontal position of the treads.
  if (positive_nosing_direction) {

  # Extend every tread except the last one.
  i_extended <- i

  if (length(i_extended) > 1) { i_extended <- i_extended[-length(i_extended)] }

  geometry$has_nosing[i_extended] <- TRUE
  geometry$x_tread_end[i_extended] <- geometry$x_tread_end[i_extended] + nosing

  # Shift intermediate risers by the nosing length.
  geometry$x_riser <- geometry$x_step_start + nosing

  # A terminal riser not followed by a tread is not shifted .
  i_terminal_riser <- which(!geometry$has_tread)
    
  geometry$x_riser[i_terminal_riser] <- geometry$x_step_start[i_terminal_riser]
  } else {

  # Extend every tread toward negative x. 
  geometry$has_nosing[i] <- TRUE
  geometry$x_tread_start[i] <- geometry$x_tread_start[i] - nosing
    
  # The riser remains at the theoretical step origin.
  geometry$x_riser <- geometry$x_step_start
  }

  # Add the vertical coordinates created by tread thickness.
  # riser_top_y is shared by the bottom of the tread and the top
  # of the riser.
  geometry$riser_top_y <- geometry$y_top - tread_thickness

  geometry$riser_bottom_y <- geometry$y_bottom - tread_thickness

  # The first riser starts on the ground rather than below it.
  geometry$riser_bottom_y[1] <- geometry$y_bottom[1]

  # Riser thickness extends toward positive x from its front face.
  geometry$x_riser_end <- geometry$x_riser + riser_thickness
  
  geometry
}