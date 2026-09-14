
#' Highlight stair steps
#'
#' Highlights selected stair steps on an existing plot.
#' The plot must already have been created with [plot_stair()].
#'
#' @param geometry A stair geometry data frame containing physical
#'   surface coordinates.
#' @param steps Integer vector of step indices to highlight.
#' @param surface Character string specifying which surfaces to draw.
#'   One of `"tread"`, `"riser"`, or `"all"`.
#' @param col Fill colour of the highlighted surfaces.
#' @param border Border colour of the highlighted surfaces.
#' @param density Hatching density passed to [graphics::polygon()].
#'   `NULL` means no hatching.
#' @param angle Hatching angle in degrees.
#' @param ... Additional graphical parameters passed to
#'   [graphics::polygon()].
#' @examples
#' \dontrun{
#' sol <- solve_stairs( total_height = 160, max_horizontal_run = 150,  tread_thickness = 4, riser_thickness = 2 )
#' g <- sol$geometry[[1]]
#' plot_stair(g)
#' highlight_stairs(  g,  steps = 3, surface = "all", col = "lightblue", border = "blue" )
#' highlight_stairs(  g,  steps = 4, surface = "tread", col = "lightblue", border = "blue" )
#' highlight_stairs(  g,  steps = 5, surface = "riser", col = "orange", border = "red" )
#' # draw lines with col = NA & density > 0
#' highlight_stairs( g, steps = 6, col = NA, border = "red", density = 20, angle = 45 )
#' }
#' @return Invisibly returns `geometry`.
#'
#' @export
highlight_stairs <- function(
    geometry,
    steps,
    surface = "tread",
    col = "yellow",
    border = "red",
    density = NULL,
    angle = 45,
    ...) {
  
  
# utility fn to draw a polygon
draw_polygon <- function(x, y, col, border, density, angle, ...) {

  graphics::polygon(
    x = x,
    y = y,
    col = col,
    border = border,
    ...
  )

  if (!is.null(density)) {
    graphics::polygon(
      x = x,
      y = y,
      col = NA,
      border = NA,
      density = density,
      angle = angle,
      ...
    )
  }
}

  required_columns <- c(
    "x_tread_start",
    "x_tread_end",
    "y_top",
    "riser_top_y",
    "x_riser",
    "x_riser_end",
    "riser_bottom_y"
  )

  missing_columns <- setdiff(
    required_columns,
    names(geometry)
  )

  if (length(missing_columns) > 0) {
    stop(
      "geometry is missing required columns: ",
      paste(missing_columns, collapse = ", "),
      call. = FALSE
    )
  }

  if (!is.numeric(steps) || anyNA(steps) ||
      any(steps < 1) ||
      any(steps != as.integer(steps))) {
    stop(
      "'steps' must contain positive integers.",
      call. = FALSE
    )
  }

  if (!is.character(surface) ||
      length(surface) != 1 ||
      !surface %in% c("tread", "riser", "all")) {
    stop(
      "'surface' must be one of: 'tread', 'riser', 'all'.",
      call. = FALSE
    )
  }

  steps <- unique(as.integer(steps))

  if (any(steps > nrow(geometry))) {
    warning(
      "Some selected steps do not exist in 'geometry'.",
      call. = FALSE
    )

    steps <- steps[steps <= nrow(geometry)]
  }

  if (length(steps) == 0) {
    return(invisible(geometry))
  }

  draw_tread <- surface %in% c("tread", "all")
  draw_riser <- surface %in% c("riser", "all")

  for (i in steps) {

    if (draw_tread && isTRUE(geometry$has_tread[i])) {

      graphics::polygon(
        x = c(
          geometry$x_tread_start[i],
          geometry$x_tread_end[i],
          geometry$x_tread_end[i],
          geometry$x_tread_start[i]
        ),
        y = c(
          geometry$y_top[i],
          geometry$y_top[i],
          geometry$riser_top_y[i],
          geometry$riser_top_y[i]
        ),
        col = col,
        border = border,
        density = density,
        angle = angle,
        ...
      )
    }

    if (draw_riser &&
        !is.na(geometry$x_riser[i])) {

      graphics::polygon(
        x = c(
          geometry$x_riser[i],
          geometry$x_riser_end[i],
          geometry$x_riser_end[i],
          geometry$x_riser[i]
        ),
        y = c(
          geometry$riser_bottom_y[i],
          geometry$riser_bottom_y[i],
          geometry$riser_top_y[i],
          geometry$riser_top_y[i]
        ),
        col = col,
        border = border,
        density = density,
        angle = angle,
        ...
      )
    }
  }

  invisible(geometry)
}
