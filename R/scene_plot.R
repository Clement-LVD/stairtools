#' Convert stair geometry into a plotting scene
#'
#' Creates a [stair_scene] from a rendered stair layout.
#' The layout should normally be created with [compute_geom_layout()]
#' when construction parameters such as nosing or tread thickness
#' must be represented.
#'
#' @param layout A rendered stair layout returned by
#'   [compute_geom_layout()] or a compatible `stair_geometry` object.
#' @examples
#' geometry <- build_geometry( n_risers = 5, step_height = 17.33, goings = rep(28.33, 4))
#' layout <- compute_geom_layout(  geometry,  nosing = 3,  tread_thickness = 4)
#' scene <- geometry_to_scene(layout)
#' plot(scene)
#' 
#' @return A `stair_scene` object.
#' @export
geometry_to_scene <- function(layout) {

  scene <- scene_build()

  scene <- scene_add_treads(
    scene,
    layout
  )

  scene <- scene_add_risers(
    scene,
    layout
  )

  scene <- scene_add_labels(
    scene,
    layout
  )

  scene
}

#' Compute the rendered stair profile from a stair geometry
#'
#' Converts a theoretical stair geometry into a rendered profile.
#' The input `going` values are measured nose-to-nose. Nosing therefore
#' shifts the visible riser position, while tread thickness reduces the
#' visible height of the riser.
#'
#' The original geometry is not modified.
#'
#' @param geometry A `stair_geometry` object returned by
#'   [build_geometry()].
#' @param nosing Nosing length, in cm. Default is `0`.
#' @param tread_thickness Tread thickness, in cm. Default is `0`.
#'
#' @return A data frame with additional columns:
#'   `riser_x` and `riser_top_y`.
#'
#' @export
compute_geom_layout <- function(geometry,
                                nosing = 0,
                                tread_thickness = 0) {

  layout <- geometry

  layout$riser_x <- geometry$x_riser
  layout$riser_top_y <- geometry$y_top

  layout$riser_x[geometry$has_tread] <-
    geometry$x_riser[geometry$has_tread] + nosing

  layout$riser_top_y[geometry$has_tread] <-
    geometry$y_top[geometry$has_tread] - tread_thickness

  layout$nosing <- nosing
  layout$tread_thickness <- tread_thickness

  layout
}

#' Initialize an empty stair plotting scene
#'
#' A scene is a pair of data.frames (`segments`, `labels`) that
#' `scene_add_*()` functions append to. Each row carries a `role`, used to
#' look up style only at plot time.
#'
#' @return A `stair_scene`: a list with empty `segments` and `labels`
#'   data.frames.
#' @export
scene_build <- function() {
  structure(
    list(
      segments = data.frame(x0 = numeric(), y0 = numeric(), x1 = numeric(), y1 = numeric(), role = character()),
      labels   = data.frame(x = numeric(), y = numeric(), text = character(), role = character())
    ),
    class = "stair_scene"
  )
}

#' Add riser segments to a stair scene
#'
#' Creates one vertical segment per riser using the rendered riser
#' coordinates.
#'
#' @param scene A `stair_scene`.
#' @param layout A rendered geometry returned by [compute_geom_layout()].
#'
#' @return The modified scene.
#'
#' @export
scene_add_risers <- function(scene, layout) {

  scene$segments <- rbind(
    scene$segments,
    data.frame(
      x0 = layout$riser_x,
      y0 = layout$y_bottom,
      x1 = layout$riser_x,
      y1 = layout$riser_top_y,
      role = "riser"
    )
  )

  scene
}

#' Add tread segments to a stair scene
#'
#' Creates one horizontal segment for each tread.
#'
#' @param scene A `stair_scene`.
#' @param layout A rendered geometry.
#'
#' @return The modified scene.
#'
#' @export
scene_add_treads <- function(scene, layout) {

  rows <- layout[layout$has_tread, ]

  scene$segments <- rbind(
    scene$segments,
    data.frame(
      x0 = rows$x_riser,
      y0 = rows$y_top,
      x1 = rows$x_going_end,
      y1 = rows$y_top,
      role = "tread"
    )
  )

  scene
}
 

scene_add_labels <- function(scene, layout) {

  rows <- layout[layout$has_tread, ]

  scene$labels <- rbind(
    scene$labels,
    data.frame(
      x = (rows$x_riser + rows$x_going_end) / 2,
      y = rows$y_top,
      text = as.character(rows$step),
      role = "step_label"
    )
  )

  scene
}

#### OLD APPROACH : TODO completing ####
#' Add overall going and rise dimension lines to a stair scene
#' @inheritParams scene_add_treads
#' @param offset Distance, in cm, between the outline and the dimension lines.
#' @export
scene_add_dimensions <- function(scene, layout, offset = 15) {
  x_min <- min(layout$x_riser); x_max <- max(layout$x_going_end, na.rm = TRUE)
  y_min <- min(layout$y_bottom); y_max <- max(layout$y_top)

  scene$segments <- rbind(scene$segments,
    data.frame(x0 = x_min, y0 = y_min - offset, x1 = x_max, y1 = y_min - offset, role = "dim"),
    data.frame(x0 = x_max + offset, y0 = y_min, x1 = x_max + offset, y1 = y_max, role = "dim")
  )
  scene$labels <- rbind(scene$labels,
    data.frame(x = (x_min + x_max) / 2, y = y_min - offset, text = sprintf("%.0f cm", x_max - x_min), role = "dim_label"),
    data.frame(x = x_max + offset, y = (y_min + y_max) / 2, text = sprintf("%.0f cm", y_max - y_min), role = "dim_label")
  )
  scene
}

#' Default per-role styling for a stair scene
#' @export
theme_default <- function() {
  list(
    tread      = list(col = "black",  lwd = 2, lty = "solid"),
    riser      = list(col = "black",  lwd = 2, lty = "solid"),
    dim        = list(col = "grey40", lwd = 1, lty = "dashed"),
    dim_label  = list(col = "grey20", cex = 0.8),
    step_label = list(col = "grey20", cex = 0.8)
  )
}

#' Plot a stair scene
#'
#' Styling only happens here -- building the scene has zero plotting cost.
#'
#' @param x A `stair_scene`.
#' @param theme A named list of per-role styles, merged over [theme_default()].
#' @param ... Passed to the underlying [plot()] call.
#' @export
plot.stair_scene <- function(x, theme = list(), ...) {
  style <- utils::modifyList(theme_default(), theme)

  xr <- range(x$segments$x0, x$segments$x1, x$labels$x)
  yr <- range(x$segments$y0, x$segments$y1, x$labels$y)
  plot(NA, xlim = xr, ylim = yr, asp = 1, xlab = "", ylab = "", axes = FALSE, ...)

  for (role in unique(x$segments$role)) {
    s <- x$segments[x$segments$role == role, ]
    p <- style[[role]]
    segments(s$x0, s$y0, s$x1, s$y1, col = p$col, lwd = p$lwd, lty = p$lty)
  }
  for (role in unique(x$labels$role)) {
    l <- x$labels[x$labels$role == role, ]
    p <- style[[role]]
    text(l$x, l$y, l$text, col = p$col, cex = p$cex)
  }
  invisible(x)
}