# Add physical stair surface geometry

Adds physical tread and riser coordinates to a theoretical stair
geometry. Theoretical dimensions such as `rise` and `going` are not
modified.

## Usage

``` r
add_stair_surface_geometry(
  geometry,
  nosing,
  nosing_direction = c("positive", "negative")
)
```

## Arguments

- geometry:

  A stair geometry data frame containing at least `x_step_start`,
  `x_going_end`, and `has_tread`.

- nosing:

  Numeric length of the nosing extension. Must be non-negative and use
  the same units as `geometry`.

- nosing_direction:

  Direction of the physical tread extension. Either `"positive"` or
  `"negative"`.

## Value

The input geometry with three additional columns: `x_tread_start`, the
horizontal coordinate of the physical beginning of the tread surface;
`x_tread_end`, the horizontal coordinate of the physical end of the
tread surface, including the nosing extension; and `x_riser`, the
horizontal coordinate of the front face of the corresponding riser.

## Details

The nosing determines the physical extent of each tread. For a positive
`nosing_direction`, treads extend beyond `x_going_end`. For a negative
`nosing_direction`, treads extend before their theoretical starting
position.

The riser position is determined from the theoretical step origin and
the nosing direction. For a positive `nosing_direction`, the riser is
shifted by the nosing length toward positive x. For a negative
`nosing_direction`, the riser remains at `x_step_start`.

## Examples

``` r
geometry <- build_geometry(
  n_risers = 5,
  step_height = 17.33,
  goings = rep(28.33, 4)
)

geometry <- add_stair_surface_geometry(
  geometry,
  nosing = 4,
  nosing_direction = "positive"
)

geometry[, c(
  "step", "x_step_start", "x_tread_start",
  "x_tread_end", "x_riser"
)]
#>   step x_step_start x_tread_start x_tread_end x_riser
#> 1    1         0.00          0.00       32.33    4.00
#> 2    2        28.33         28.33       60.66   32.33
#> 3    3        56.66         56.66       88.99   60.66
#> 4    4        84.99         84.99      113.32   88.99
#> 5    5       113.32        113.32          NA  117.32

geometry <- add_stair_surface_geometry(
  build_geometry(
    n_risers = 5,
    step_height = 17.33,
    goings = rep(28.33, 4)
  ),
  nosing = 4,
  nosing_direction = "negative"
)

geometry[, c(
  "step", "x_step_start", "x_tread_start",
  "x_tread_end", "x_riser"
)]
#>   step x_step_start x_tread_start x_tread_end x_riser
#> 1    1         0.00         -4.00       28.33    0.00
#> 2    2        28.33         24.33       56.66   28.33
#> 3    3        56.66         52.66       84.99   56.66
#> 4    4        84.99         80.99      113.32   84.99
#> 5    5       113.32        113.32          NA  113.32
```
