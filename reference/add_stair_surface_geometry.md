# Add physical stair surface geometry

Adds physical tread and riser coordinates to a theoretical stair
geometry. Theoretical dimensions such as `rise` and `going` are not
modified.

## Usage

``` r
add_stair_surface_geometry(
  geometry,
  nosing,
  positive_nosing_direction = TRUE,
  tread_thickness = 0,
  riser_thickness = 0
)
```

## Arguments

- geometry:

  `data.frame` - A stair geometry data frame containing at least
  `x_step_start`, `x_going_end`, `y_top`, `y_bottom`, and `has_tread`.

- nosing:

  `numeric` - length of the nosing extension. Must be non-negative and
  use the same units as `geometry`.

- positive_nosing_direction:

  `logical` - If `TRUE`, the nosing extends toward the positive x-axis.
  If `FALSE`, it extends toward the negative x-axis.

- tread_thickness:

  `numeric` - Tread thickness (cm). Defaults to `0`.

- riser_thickness:

  `numeric` - Riser thickness (cm). Defaults to `0`.

## Value

The input geometry with additional physical surface coordinates and
logical variable.

## Details

The nosing determines the physical extent of each tread. When
`positive_nosing_direction` is `TRUE`, treads are extended toward
positive x, except for the last tread. When it is `FALSE`, all treads
are extended toward negative x.

The riser position is determined from the theoretical step origin. When
`positive_nosing_direction` is `TRUE`, intermediate risers are shifted
by the nosing length toward positive x, while the last riser remains at
`x_step_start`. When it is `FALSE`, all risers remain at `x_step_start`.

Tread and riser thicknesses define the physical geometry of the
corresponding elements. The bottom of the tread and the top of the riser
share the same vertical coordinate, `riser_top_y`.

A concrete stair can be represented by setting `nosing`,
`tread_thickness`, and `riser_thickness` to zero.

## Examples

``` r
geometry <- add_stair_surface_geometry(build_geometry(5, 17.33, rep(28.33, 4)), 4)
geometry
#>   step x_step_start y_bottom y_top  rise going x_going_end has_tread
#> 1    1         0.00     0.00 17.33 17.33 28.33       28.33      TRUE
#> 2    2        28.33    17.33 34.66 17.33 28.33       56.66      TRUE
#> 3    3        56.66    34.66 51.99 17.33 28.33       84.99      TRUE
#> 4    4        84.99    51.99 69.32 17.33 28.33      113.32      TRUE
#> 5    5       113.32    69.32 86.65 17.33    NA          NA     FALSE
#>   x_tread_start x_tread_end has_nosing x_riser riser_top_y riser_bottom_y
#> 1          0.00       32.33       TRUE    4.00       17.33           0.00
#> 2         28.33       60.66       TRUE   32.33       34.66          17.33
#> 3         56.66       88.99       TRUE   60.66       51.99          34.66
#> 4         84.99      113.32      FALSE   88.99       69.32          51.99
#> 5        113.32          NA      FALSE  113.32       86.65          69.32
#>   x_riser_end
#> 1        4.00
#> 2       32.33
#> 3       60.66
#> 4       88.99
#> 5      113.32

geometry <- add_stair_surface_geometry(build_geometry(5, 17.33, rep(28.33, 4)), 4, FALSE, 4, 3)
geometry[, c("x_tread_start", "x_tread_end", "riser_top_y", "riser_bottom_y", "x_riser_end")]
#>   x_tread_start x_tread_end riser_top_y riser_bottom_y x_riser_end
#> 1         -4.00       28.33       13.33           0.00        3.00
#> 2         24.33       56.66       30.66          13.33       31.33
#> 3         52.66       84.99       47.99          30.66       59.66
#> 4         80.99      113.32       65.32          47.99       87.99
#> 5        113.32          NA       82.65          65.32      116.32

# A concrete stair: no nosing, zero tread and riser thickness.
geometry <- add_stair_surface_geometry(build_geometry(5, 17.33, rep(28.33, 4)), 0, TRUE, 0, 0)
str(geometry)
#> Classes ‘stair_geometry’ and 'data.frame':   5 obs. of  15 variables:
#>  $ step          : int  1 2 3 4 5
#>  $ x_step_start  : num  0 28.3 56.7 85 113.3
#>  $ y_bottom      : num  0 17.3 34.7 52 69.3
#>  $ y_top         : num  17.3 34.7 52 69.3 86.6
#>  $ rise          : num  17.3 17.3 17.3 17.3 17.3
#>  $ going         : num  28.3 28.3 28.3 28.3 NA
#>  $ x_going_end   : num  28.3 56.7 85 113.3 NA
#>  $ has_tread     : logi  TRUE TRUE TRUE TRUE FALSE
#>  $ x_tread_start : num  0 28.3 56.7 85 113.3
#>  $ x_tread_end   : num  28.3 56.7 85 113.3 NA
#>  $ has_nosing    : logi  TRUE TRUE TRUE FALSE FALSE
#>  $ x_riser       : num  0 28.3 56.7 85 113.3
#>  $ riser_top_y   : num  17.3 34.7 52 69.3 86.6
#>  $ riser_bottom_y: num  0 17.3 34.7 52 69.3
#>  $ x_riser_end   : num  0 28.3 56.7 85 113.3
```
