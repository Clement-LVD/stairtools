# Plot a stair profile

Draws the profile of a staircase from a geometry data frame produced by
[`build_geometry`](https://clement-lvd.github.io/stairtools/reference/build_geometry.md).

## Usage

``` r
plot_stair_basic(
  geometry,
  col_step = "black",
  col_floor = "gray50",
  show_coordinates = FALSE,
  cex_dimensions = 0.8,
  ...
)
```

## Arguments

- geometry:

  A data frame of class `stair_geometry` returned by
  [`build_geometry`](https://clement-lvd.github.io/stairtools/reference/build_geometry.md).

- col_step:

  Colour used to draw step segments. Default is `"black"`.

- col_floor:

  Colour used for finished floor reference lines. Default is `"gray50"`.

- show_coordinates:

  Logical. If `TRUE`, cumulative horizontal and vertical dimensions are
  displayed. Default is `FALSE`.

- cex_dimensions:

  Character expansion factor for dimension labels. Default is `0.6`.

- ...:

  Additional graphical parameters passed to
  [`plot`](https://rdrr.io/r/graphics/plot.default.html).

## Details

Each step is represented by a vertical rise and a horizontal going. The
lower and upper finished floor levels are displayed as dashed reference
lines.

Objects returned by
[`build_geometry`](https://clement-lvd.github.io/stairtools/reference/build_geometry.md)
inherit from the `stair_geometry` class, allowing direct use of
[`plot()`](https://rdrr.io/r/graphics/plot.default.html).

## Examples

``` r
geometry <- build_geometry(5, 17.33, rep(28.33, 4))
plot_stair_basic(geometry)
#> Error in plot_stair_basic(geometry): object 'i' not found

plot(geometry)
#> Error: geometry is missing required columns: x_tread_start, x_tread_end, x_riser. Call add_stair_surface_geometry() first.

plot_stair_basic(geometry, show_coordinates = TRUE)
#> Error in plot_stair_basic(geometry, show_coordinates = TRUE): object 'i' not found
```
