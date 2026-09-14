#' Create a polygon drawing instruction
#'
#' Basic converting of 2 vectors and a `step` column into a polygon list structure
#' 
#' @param data `data.frame` containing polygon coordinates.
#' @param i Row index.
#' @param x Character vector of x coordinate column names.
#' @param y Character vector of y coordinate column names.
#'
#' @return A polygon drawing instruction.
#'
#' @keywords internal
.create_polygon <- function(data, i, x, y) {

  if (length(x) != length(y) || length(x) < 3L) {
    stop("Invalid polygon coordinates.", call. = FALSE)
  }

  if (!all(c(x, y) %in% names(data))) {
    stop("Some polygon coordinate columns are missing.", call. = FALSE)
  }

  list(
    x = vapply(x, function(name) data[[name]][i], numeric(1)),
    y = vapply(y, function(name) data[[name]][i], numeric(1)),
    step = data$step[i],
    surface = NULL,
    params = list()
  )
}


#' Create stair polygon drawing instructions
#'
#' Converts stair geometry into polygon drawing instructions.
#'
#' @param geometry `stair_geometry` data frame : columns names are hardcoded hereafter, in order to convert geometry into a polygon list of coordinates.
#' @param riser Logical; whether to include riser polygons.
#'
#' @return A list of polygon drawing instructions.
#'
#' @keywords internal
create_stair_polygons <- function(geometry, riser = TRUE) {

  tread_x <- c(
    "x_tread_start", "x_tread_end",
    "x_tread_end", "x_tread_start"
  )

  tread_y <- c(
    "y_top", "y_top",
    "riser_top_y", "riser_top_y"
  )

  tread <- lapply(
    which(geometry$has_tread),
    function(i) {
      p <- .create_polygon(geometry, i, tread_x, tread_y)
      p$surface <- "tread"
      p
    }
  )

  if (!riser) {
    return(tread)
  }

  riser_x <- c(
    "x_riser", "x_riser_end",
    "x_riser_end", "x_riser"
  )

  riser_y <- c(
    "riser_bottom_y", "riser_bottom_y",
    "riser_top_y", "riser_top_y"
  )

  risers <- lapply(
    which(!is.na(geometry$x_riser)),
    function(i) {
      p <- .create_polygon(geometry, i, riser_x, riser_y)
      p$surface <- "riser"
      p
    }
  )

  c(tread, risers)
}


#' Apply styles to stair polygons
#'
#' Applies graphical parameters accepted by [graphics::polygon()] to
#' selected stair polygons. Styles are applied in order, so later styles
#' override parameters set by earlier styles.
#'
#' @param polygons List of polygon drawing instructions.
#' @param polygon_params Named list of default parameters passed to
#'   [graphics::polygon()].
#' @param styles List of style rules. Each rule may contain `steps` and
#'   `surface` selectors in addition to graphical parameters accepted by
#'   [graphics::polygon()]. A missing or `NULL` selector matches all
#'   polygons.
#'
#' @return The modified polygon list.
#'
#' @keywords internal
style_stair_polygons <- function(
    polygons,
    polygon_params = list(),
    styles = NULL) {

  for (i in seq_along(polygons)) {
    polygons[[i]]$params <- polygon_params
  }

  if (is.null(styles)) {
    return(polygons)
  }

  if (!is.list(styles)) {
    stop("`styles` must be a list.", call. = FALSE)
  }

  for (style in styles) {

    if (!is.list(style)) {
      stop("Each element of `styles` must be a list.", call. = FALSE)
    }

    steps <- if ("steps" %in% names(style)) style$steps else NULL
    surface <- if ("surface" %in% names(style)) style$surface else NULL

    params <- style
    params$steps <- NULL
    params$surface <- NULL

    for (i in seq_along(polygons)) {

      selected <- TRUE

      if (!is.null(steps)) {
        selected <- polygons[[i]]$step %in% steps
      }

      if (selected && !is.null(surface)) {
        selected <- polygons[[i]]$surface %in% surface
      }

      if (selected && length(params)) {
        polygons[[i]]$params[names(params)] <- params
      }
    }
  }

  polygons
}


#' Draw a stair polygon
#'
#' @param polygon A polygon drawing instruction.
#'
#' @return Invisibly returns `NULL`.
#'
#' @keywords internal
.draw_stair_polygon <- function(polygon) {

  do.call(
    graphics::polygon,
    c(
      list(x = polygon$x, y = polygon$y),
      polygon$params
    )
  )

  invisible(NULL)
}


#' Plot a stair geometry
#'
#' Plots a stair geometry using its physical tread and riser surfaces.
#' Graphical parameters are passed directly to [graphics::polygon()].
#'
#' @param geometry A `stair_geometry` data frame.
#' @param riser Logical; whether to draw risers. Defaults to `TRUE`.
#' @param polygon_params Named list of graphical parameters passed to
#'   [graphics::polygon()]. Common parameters include `col`, `border`,
#'   `density`, `angle`, `lty`, and `lwd`.
#' @param styles List of style rules applied after `polygon_params`.
#'   Each rule may contain `steps` and `surface` selectors. Missing or
#'   `NULL` selectors match all polygons. Rules are applied in order.
#' @param legend_columns Named character vector of geometry columns to
#'   display as horizontal axes.
#' @param axis_y_columns Named character vector of geometry columns to
#'   display as vertical axes.
#' @param xlim Optional x-axis limits.
#' @param ylim Optional y-axis limits.
#' @param asp Plot aspect ratio.
#'
#' @return Invisibly returns the polygon drawing instructions.
#'
#' @examples
#' sol <- solve_stairs(103, 133)
#' plot_stair(sol$geometry[[1]])
#'
#' plot_stair(
#'   sol$geometry[[1]],
#'   polygon_params = list(col = "white", border = "black"),
#'   styles = list(
#'     list(
#'       steps = 3,
#'       density = 20,
#'       angle = 45
#'     )
#'   )
#' )
#'
#' @export
plot_stair <- function(
    geometry,
    riser = TRUE,
    polygon_params = list(
      col = "white",
      border = "black"
    ),
    styles = NULL,
    legend_columns = c(
      "Step begin" = "x_tread_start",
      "Step end" = "x_tread_end",
      "Riser" = "x_riser"
    ),
    axis_y_columns = c( "Step height" = "y_top" ), #, "Riser bottom" =  "riser_bottom_y"
    xlim = NULL,
    ylim = NULL,
    asp = 1) {

  required_columns <- c(
    "x_tread_start",
    "x_tread_end",
    "x_riser",
    "riser_top_y",
    "riser_bottom_y",
    "x_riser_end"
  )

  missing_columns <- setdiff(required_columns, names(geometry))

  if (length(missing_columns)) {
    stop(
      "geometry is missing required columns: ",
      paste(missing_columns, collapse = ", "),
      ". Call add_stair_surface_geometry() first.",
      call. = FALSE
    )
  }

  polygons <- create_stair_polygons(
    geometry = geometry,
    riser = riser
  )

  polygons <- style_stair_polygons(
    polygons = polygons,
    polygon_params = polygon_params,
    styles = styles
  )

  x <- unlist(lapply(polygons, `[[`, "x"), use.names = FALSE)
  y <- unlist(lapply(polygons, `[[`, "y"), use.names = FALSE)

  if (is.null(xlim)) {
    xlim <- range(x, na.rm = TRUE)
  }

  if (is.null(ylim)) {
    ylim <- range(y, na.rm = TRUE)
  }

  n_legend <- if (is.null(legend_columns)) {
    0L
  } else {
    sum(
      !is.na(legend_columns) &
      legend_columns %in% names(geometry)
    )
  }

  old_mar <- graphics::par("mar")

  if (n_legend > 0L) {
    graphics::par(
      mar = c(
        max(old_mar[1], 2 * n_legend + 1),
        old_mar[2:4]
      )
    )

    on.exit(graphics::par(mar = old_mar), add = TRUE)
  }

  graphics::plot.new()

  graphics::plot.window(
    xlim = xlim,
    ylim = ylim,
    asp = asp
  )

  for (polygon in polygons) {
    .draw_stair_polygon(polygon)
  }

  if (!is.null(legend_columns) && riser) {
    add_axis_from_columns(
      geometry,
      legend_columns
    )
  } else if (!is.null(legend_columns)) {
    add_axis_from_columns(
      geometry,
      legend_columns[legend_columns != "x_riser"]
    )
  }

  add_axis_from_columns_vertical(
    geometry,
    axis_y_columns
  )

  graphics::box()

  invisible(polygons)
}

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

add_axis_from_columns_vertical <- function(g, columns, ...) {

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

    y <- g[[columns[i]]]
    y <- sort(unique(y[!is.na(y)]))

    if (length(y) == 0) {
      next
    }

    graphics::axis(
      side = 2,
      at = y,
      labels = format(y, trim = TRUE),
      line = 2 * (i - 1),
      ...
    )

    if (!is.null(titles) &&
        length(titles) >= i &&
        !is.na(titles[i]) &&
        nzchar(titles[i])) {

      graphics::mtext(
        text = titles[i],
        side = 2,
        line = 2 * (i - 1) - 1.1,
        adj = 1,
        cex = 0.9
        #,   las = 1,
      )
    }
  }

  invisible(g)
}
