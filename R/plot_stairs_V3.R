#' Add axes from data frame columns
#'
#' Adds one horizontal axis for each valid data frame column. Each column
#' is displayed on a separate axis line. Unknown columns are ignored.
#'
#' @param g A data frame containing the values to display.
#' @param columns Character vector of column names. Optional names are used
#'   as axis titles.
#' @param ... Graphical parameters passed to \code{graphics::axis()}.
#'
#' @return Invisibly returns `g`.
#'
#' @export
add_axis_from_columns <- function(g, columns, ...) {

  if (is.null(columns) || length(columns) == 0) {
    return(invisible(g))
  }

  valid <- !is.na(columns) & columns %in% names(g)

  if (!any(valid)) {
    return(invisible(g))
  }

  columns <- columns[valid]
  titles <- names(columns)

  for (i in seq_along(columns)) {

    x <- g[[columns[i]]]
    x <- sort(unique(x[!is.na(x)]))

    if (length(x) == 0) {
      next
    }

    graphics::axis(
      side = 1,
      at = x,
      labels = format(x, trim = TRUE),
      line = 2 * (i - 1),
      ...
    )

    if (!is.null(titles) &&
        length(titles) >= i &&
        !is.na(titles[i]) &&
        nzchar(titles[i])) {

      graphics::mtext(
        text = titles[i],
        side = 1,
        line = 2 * (i - 1) - 0.1,
        adj = 1,
        cex = 0.7
      )
    }
  }

  invisible(g)
}

#' Plot a stair geometry
#'
#' Plots a stair geometry using physical tread and riser surfaces.
#' Physical surface coordinates and thicknesses must already have been
#' added with \code{add_stair_surface_geometry()}.
#'
#' @param geometry A stair geometry data frame containing physical
#'   surface coordinates.
#' @param riser Logical; whether to draw risers.
#' @param legend_columns Character vector of geometry columns to display
#'   as horizontal axes. Each column is displayed on a separate line.
#'   Unknown columns are ignored. If `NULL` or if no valid column is
#'   supplied, no axes are displayed.
#' @param col Fill colour of the stair surfaces.
#' @param border Border colour of the stair surfaces.
#' @param ... Additional graphical parameters passed to
#'   \code{graphics::plot()}.
#'
#' @return Invisibly returns `geometry`.
#' @examples
#' sol <- solve_stairs(total_height = 160, 150, tread_thickness = 4, riser_thickness = 2)
#' plot_stair(sol$geometry[[1]])
#' 
#' sol2 <- solve_stairs(total_height = 60, 150, tread_thickness = 4,nosing = 4)
#' # no riser stair :
#' plot_stair(sol2$geometry[sol$has_landing][[1]],  riser = FALSE)
#' @export
plot_stair <- function(
    geometry,
    riser = TRUE,
    legend_columns = c(
      "Step begin" = "x_tread_start",
      "Step end" = "x_tread_end",
      "Riser" = "x_riser"
    ),
    col = "white",
    border = "black",
    ...) {

  required_columns <- c(
    "x_tread_start",
    "x_tread_end",
    "x_riser",
    "riser_top_y",
    "riser_bottom_y",
    "x_riser_end"
  )

  missing_columns <- setdiff(
    required_columns,
    names(geometry)
  )

  if (length(missing_columns) > 0) {
    stop(
      "geometry is missing required columns: ",
      paste(missing_columns, collapse = ", "),
      ". Call add_stair_surface_geometry() first.",
      call. = FALSE
    )
  }

  x <- c(
    geometry$x_tread_start,
    geometry$x_tread_end,
    geometry$x_riser,
    geometry$x_riser_end
  )

  y <- c(
    geometry$riser_bottom_y,
    geometry$riser_top_y,
    geometry$y_top
  )

  # Enlarge the bottom margin when several axes are displayed.
  n_legend <- 0

  if (!is.null(legend_columns)) {
    n_legend <- sum(
      !is.na(legend_columns) &
      legend_columns %in% names(geometry)
    )
  }

  old_mar <- graphics::par("mar")

  if (n_legend > 0) {
    graphics::par(
      mar = c(
        max(old_mar[1], 2 * n_legend + 1),
        old_mar[2:4]
      )
    )

    on.exit(
      graphics::par(mar = old_mar),
      add = TRUE
    )
  }

  # Create an empty plot.
  graphics::plot(
    NA,
    xlim = range(x, na.rm = TRUE),
    ylim = range(y, na.rm = TRUE),
    asp = 1,
    axes = FALSE,
    xlab = "",
    ylab = "",
    ...
  )

  # Treads
  for (i in which(geometry$has_tread)) {

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
      border = border
    )
  }

  # Risers
  if (riser) {

    for (i in which(!is.na(geometry$x_riser))) {

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
        border = border
      )
    }
  } else {legend_columns <- legend_columns[legend_columns != "x_riser"] }

  add_axis_from_columns(
    geometry,
    legend_columns
  )

  invisible(geometry)
}