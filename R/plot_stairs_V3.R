 
#' Compute fine stair geometry
#'
#' Adds the coordinates required to represent tread and riser thickness.
#' Physical tread and riser positions are taken from the surface geometry.
#'
#' @param geometry A stair geometry data frame containing physical
#'   surface coordinates.
#' @param tread_thickness Thickness of the tread.
#' @param riser_thickness Thickness of the riser.
#'
#' @return The geometry with `riser_top_y` and `x_riser_end` columns.
#' @examples
#' \dontrun{
#' geometry <- add_stair_surface_geometry( build_geometry( n_risers = 5, step_height = 17.33
#' , goings = rep(28.33, 4) ), nosing = 4, nosing_direction = "negative" )
#' 
#' g <- compute_geom_fine( geometry, tread_thickness = 4, riser_thickness = 3 )
#' }
#' @export
compute_geom_fine <- function(
    geometry,
    tread_thickness = 0,
    riser_thickness = 0) {

  geometry$riser_top_y <-
    geometry$y_top - tread_thickness

  geometry$riser_bottom_y <-
    geometry$y_bottom - tread_thickness

  # The first riser starts on the ground.
  geometry$riser_bottom_y[1] <-
    geometry$y_bottom[1]

  # Riser thickness extends towards positive x.
  geometry$x_riser_end <-
    geometry$x_riser + riser_thickness

  geometry
}


#' Add axes from data frame columns
#'
#' Adds one axis for each valid data frame column. Each column is displayed
#' on a separate axis line. Unknown columns are ignored.
#'
#' @param g A data frame containing the values to display.
#' @param columns Character vector of column names. Optional names are used
#'   as axis titles.
#' @param ... Graphical parameters passed to \code{axis()}.
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

    axis(
      side = 1,
      at = x,
      labels = format(x, trim = TRUE),
      line = 2 * (i - 1),
      ...
    )

    if (!is.null(titles) &&
        !is.na(titles[i]) &&
        nzchar(titles[i])) {

      mtext(cex = 0.7,
        titles[i],
        side = 1,
        line = 2 * (i - 1) - 0.1,
        adj = 1
      )
    }
  }

  invisible(g)
}
 #' Plot a fine stair geometry
#'
#' Plots a stair geometry using physical tread and riser surfaces,
#' including their thicknesses.
#'
#' @param geometry A stair geometry data frame containing physical
#'   surface coordinates.
#' @param tread_thickness Thickness of the tread.
#' @param riser_thickness Thickness of the riser.
#' @param riser Logical; whether to draw risers.
#' @param legend_columns Character vector of geometry columns to display
#'   as horizontal axes. Each column is displayed on a separate line.
#'   Unknown columns are ignored. If `NULL` or if no valid column is
#'   supplied, no axes are displayed.
#' @param col Fill colour of the stair surfaces.
#' @param border Border colour of the stair surfaces.
#' @param ... Additional graphical parameters passed to \code{plot()}.
#'
#' @return Invisibly returns the fine geometry used for plotting.
#'
#' @export
plot_stair <- function(
    geometry,
    tread_thickness = 0,
    riser_thickness = 0,
    riser = TRUE,
    legend_columns =  c(
  "Step begin" = "x_tread_start",
  "Step end"   = "x_tread_end",
  "Riser"      = "x_riser"
),
    col = "white",
    border = "black",
    ...) {

  required_columns <- c(
    "x_tread_start",
    "x_tread_end",
    "x_riser"
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

  g <- compute_geom_fine(
    geometry,
    tread_thickness = tread_thickness,
    riser_thickness = riser_thickness
  )

  x <- c(
    g$x_tread_start,
    g$x_tread_end,
    g$x_riser,
    g$x_riser_end
  )

  y <- c(
    g$riser_bottom_y,
    g$riser_top_y,
    g$y_top
  )
  
  # Enlarge the bottom margin when several axes are displayed.
  n_legend <- 0

  if (!is.null(legend_columns)) {n_legend <- sum(!is.na(legend_columns) &legend_columns %in% names(g))}

  old_mar <- par("mar")

  if (n_legend > 0) {par(mar = c(
        max(old_mar[1], 2 * n_legend + 1),
        old_mar[2:4]      )    )
    
    on.exit(par(mar = old_mar), add = TRUE)
  }

  # made an empty plot
  plot(
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
  for (i in which(g$has_tread)) {

    polygon(
      x = c(
        g$x_tread_start[i],
        g$x_tread_end[i],
        g$x_tread_end[i],
        g$x_tread_start[i]
      ),
      y = c(
        g$y_top[i],
        g$y_top[i],
        g$riser_top_y[i],
        g$riser_top_y[i]
      ),
      col = col,
      border = border
    )
  }

  # Risers
  if (riser) {

    for (i in which(!is.na(g$x_riser))) {

      polygon(
        x = c(
          g$x_riser[i],
          g$x_riser_end[i],
          g$x_riser_end[i],
          g$x_riser[i]
        ),
        y = c(
          g$riser_bottom_y[i],
          g$riser_bottom_y[i],
          g$riser_top_y[i],
          g$riser_top_y[i]
        ),
        col = col,
        border = border
      )
    }
  }

  add_axis_from_columns(
    g,
    legend_columns
  )

  invisible(g)
}