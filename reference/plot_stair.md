# Plot a fine stair geometry

Plots a stair geometry using physical tread and riser surfaces,
including their thicknesses.

## Usage

``` r
# S3 method for class 'stair_geometry'
plot(x, ...)

plot_stair(
  geometry,
  tread_thickness = 0,
  riser_thickness = 0,
  riser = TRUE,
  legend_columns = c(`Step begin` = "x_tread_start", `Step end` = "x_tread_end", Riser =
    "x_riser"),
  col = "white",
  border = "black",
  ...
)
```

## Arguments

- x:

  A `stair_geometry` object.

- ...:

  Additional graphical parameters passed to
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html).

- geometry:

  A stair geometry data frame containing physical surface coordinates.

- tread_thickness:

  Thickness of the tread.

- riser_thickness:

  Thickness of the riser.

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

## Value

Invisibly returns the fine geometry used for plotting.
