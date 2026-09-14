# Plot a stair geometry

Plots a stair geometry using its physical tread and riser surfaces.
Graphical parameters are passed directly to
[`graphics::polygon()`](https://rdrr.io/r/graphics/polygon.html).

## Usage

``` r
plot_stair(
  geometry,
  riser = TRUE,
  polygon_params = list(col = "white", border = "black"),
  styles = NULL,
  legend_columns = c(`Step begin` = "x_tread_start", `Step end` = "x_tread_end", Riser =
    "x_riser"),
  axis_y_columns = c(`Step height` = "y_top"),
  xlim = NULL,
  ylim = NULL,
  asp = 1
)
```

## Arguments

- geometry:

  A `stair_geometry` data frame.

- riser:

  Logical; whether to draw risers. Defaults to `TRUE`.

- polygon_params:

  Named list of graphical parameters passed to
  [`graphics::polygon()`](https://rdrr.io/r/graphics/polygon.html).
  Common parameters include `col`, `border`, `density`, `angle`, `lty`,
  and `lwd`.

- styles:

  List of style rules applied after `polygon_params`. Each rule may
  contain `steps` and `surface` selectors. Missing or `NULL` selectors
  match all polygons. Rules are applied in order.

- legend_columns:

  Named character vector of geometry columns to display as horizontal
  axes.

- axis_y_columns:

  Named character vector of geometry columns to display as vertical
  axes.

- xlim:

  Optional x-axis limits.

- ylim:

  Optional y-axis limits.

- asp:

  Plot aspect ratio.

## Value

Invisibly returns the polygon drawing instructions.

## Examples

``` r
sol <- solve_stairs(103, 133)
plot_stair(sol$geometry[[1]])


plot_stair(
  sol$geometry[[1]],
  polygon_params = list(col = "white", border = "black"),
  styles = list(
    list(
      steps = 3,
      density = 20,
      angle = 45
    )
  )
)

```
