# Plot a stair geometry

Plots a stair geometry using physical tread and riser surfaces. Physical
surface coordinates and thicknesses must already have been added with
[`add_stair_surface_geometry()`](https://clement-lvd.github.io/stairtools/reference/add_stair_surface_geometry.md).

## Usage

``` r
plot_stair(
  geometry,
  riser = TRUE,
  legend_columns = c(`Step begin` = "x_tread_start", `Step end` = "x_tread_end", Riser =
    "x_riser"),
  col = "white",
  border = "black",
  ...
)
```

## Arguments

- geometry:

  A stair geometry data frame containing physical surface coordinates.

- riser:

  Logical; whether to draw risers.

- legend_columns:

  Character vector of geometry columns to display as horizontal axes.
  Each column is displayed on a separate line. Unknown columns are
  ignored. If `NULL` or if no valid column is supplied, no axes are
  displayed.

- col:

  Fill colour of the stair surfaces.

- border:

  Border colour of the stair surfaces.

- ...:

  Additional graphical parameters passed to
  [`graphics::plot()`](https://rdrr.io/r/graphics/plot.default.html).

## Value

Invisibly returns `geometry`.

## Examples

``` r
sol <- solve_stairs(total_height = 160, 150, tread_thickness = 4, riser_thickness = 2)
plot_stair(sol$geometry[[1]])


sol2 <- solve_stairs(total_height = 60, 150, tread_thickness = 4,nosing = 4)
# no riser stair :
plot_stair(sol2$geometry[sol$has_landing][[1]],  riser = FALSE)
```
