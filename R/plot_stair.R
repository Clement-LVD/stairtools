#' Plot a stair profile
#'
#' Draws the profile of a staircase from a geometry data frame produced by
#' \code{\link{build_geometry}}.
#'
#' Each step is represented by a vertical rise and a horizontal going.
#' The lower and upper finished floor levels are displayed as dashed
#' reference lines.
#'
#' Objects returned by \code{\link{build_geometry}} inherit from the
#' \code{stair_geometry} class, allowing direct use of
#' \code{plot()}.
#'
#' @param geometry A data frame of class \code{stair_geometry} returned by
#'   \code{\link{build_geometry}}.
#' @param col_step Colour used to draw step segments. Default is
#'   \code{"black"}.
#' @param col_floor Colour used for finished floor reference lines.
#'   Default is \code{"gray50"}.
#' @param show_dimensions Logical. If \code{TRUE}, cumulative horizontal
#'   and vertical dimensions are displayed. Default is \code{FALSE}.
#' @param cex_dimensions Character expansion factor for dimension labels.
#'   Default is \code{0.6}.
#' @param ... Additional graphical parameters passed to
#'   \code{\link[graphics]{plot}}.
#'
#' @examples
#' geometry <- build_geometry(5, 17.33, rep(28.33, 4))
#' plot_stair(geometry)
#'
#' plot(geometry)
#'
#' plot_stair(geometry, show_dimensions = TRUE)
#'
#' @export
plot_stair <- function(geometry,
                       col_step = "black",
                       col_floor = "gray50",
                       show_dimensions = FALSE,
                       cex_dimensions = 0.8,
                       ...) {

  if (nrow(geometry) == 0) {
    graphics::plot.new()
    return(invisible())
  }

  x_max <- max(
    geometry$x_going_end,
    geometry$x_riser,
    na.rm = TRUE
  )

  y_max <- max(geometry$y_top, na.rm = TRUE)

  # we need margin for plot the dimensions label under axes x
dimension_margin <- if (show_dimensions) 0.15 * x_max else 0

graphics::plot(
  NA,
  xlim = c(0, x_max),
  ylim = c(-dimension_margin, y_max),
  asp = 1,
  xlab = "Horizontal distance (cm)",
  ylab = "Height (cm)",
  ...
)

  # Finished floor levels
  graphics::abline(
    h = c(0, y_max),
    lty = 2,
    col = col_floor
  )

  for (i in seq_len(nrow(geometry))) {

    # Vertical rise
    graphics::segments(
      geometry$x_riser[i],
      geometry$y_bottom[i],
      geometry$x_riser[i],
      geometry$y_top[i],
      lwd = 2
    )

    # Horizontal going (not present for the last step)
    if (!is.na(geometry$going[i])) {

      graphics::segments(
        geometry$x_riser[i],
        geometry$y_top[i],
        geometry$x_going_end[i],
        geometry$y_top[i],
        lwd = 2,
        col = col_step
      )
    }
  }

  if (show_dimensions) {
    .plot_stair_dimensions(
      geometry,
      cex_dimensions = cex_dimensions
    )
  }

  invisible(geometry)
}


#' Plot stair dimensions
#'
#' Adds cumulative horizontal and vertical dimensions to a stair profile.
#'
#' This is a helper function used by \code{\link{plot_stair}} when
#' \code{show_dimensions = TRUE}.
#'
#' @param geometry A stair geometry data frame.
#' @param cex_dimensions Character expansion factor for labels.
#'
#' @keywords internal
.plot_stair_dimensions <- function(geometry,
                                   cex_dimensions = 0.8) {

  x_positions <- geometry$x_going_end[
    !is.na(geometry$x_going_end)
  ]

  y_line <- -0.05 * max(geometry$x_going_end, na.rm = TRUE)
y_text <- -0.10 * max(geometry$x_going_end, na.rm = TRUE)

graphics::segments(
  x_positions,
  0,
  x_positions,
  y_line,
  lty = 3,
  col = "gray60"
)

graphics::text(
  x_positions,
  y_text,
  round(x_positions, 1),
  srt = 90,
  cex = cex_dimensions,
  xpd = TRUE
)


  graphics::segments(
    0,
    geometry$y_top,
    -5,
    geometry$y_top,
    lty = 3,
    col = "gray60"
  )

  graphics::text(
    -8,
    geometry$y_top,
    round(geometry$y_top, 1),
    cex = cex_dimensions,
    xpd = TRUE
  )
}


#' Plot a stair profile with dimensions
#'
#' Shortcut for \code{plot_stair(..., show_dimensions = TRUE)}.
#'
#' @param geometry A stair geometry data frame returned by
#'   \code{\link{build_geometry}}.
#' @param ... Additional arguments passed to
#'   \code{\link{plot_stair}}.
#'
#' @examples
#' geometry <- build_geometry(5, 17.33, rep(28.33, 4))
#' plot_stair_dimensions(geometry)
#'
#' @export
plot_stair_dimensions <- function(geometry, ...) {
  plot_stair(
    geometry,
    show_dimensions = TRUE,
    ...
  )
}


#' @export
#' @rdname plot_stair
#' @method plot stair_geometry
#' @param x A \code{stair_geometry} object.
plot.stair_geometry <- function(x, ...) {
  plot_stair(x, ...)
}