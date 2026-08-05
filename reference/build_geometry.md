# Build the complete geometry of a stair

Computes the geometry of each riser by determining its horizontal
position (the cumulative width of the preceding goings) together with
its bottom and top elevations.

## Usage

``` r
build_geometry(n_risers, step_height, goings)
```

## Arguments

- n_risers:

  Number of risers.

- step_height:

  Uniform riser height.

- goings:

  Numeric vector of going lengths, with length `n_risers - 1` (standard
  stair) or `n_risers` (including a landing going).

## Value

Return a `data.frame` with one row per riser and the following columns:
`step`, `x_riser`, `y_bottom`, `y_top`, `going`, `x_going_end`, and
`going_type`.

## Details

Two going configurations are supported:

- A vector of length `n_risers - 1`, corresponding to a conventional
  stair where the last riser reaches the landing directly, with no going
  beyond it.

- A vector of length `n_risers`, corresponding to a stair with an
  additional landing going after the last riser, at the same elevation
  as the destination landing.

The returned geometry is intended to be plotted directly using
[`segments()`](https://rdrr.io/r/graphics/segments.html) in base R:

- Riser *i* (vertical): from `(x_riser, y_bottom)` to
  `(x_riser, y_top)`.

- Going *i* (horizontal), when present: from `(x_riser, y_top)` to
  `(x_going_end, y_top)`.

## Examples

``` r
geometry <- build_geometry(n_risers = 5, step_height = 17.33, goings = rep(28.33, 4) )
geometry
#>   step x_riser y_bottom y_top  rise going x_going_end has_tread
#> 1    1    0.00     0.00 17.33 17.33 28.33       28.33      TRUE
#> 2    2   28.33    17.33 34.66 17.33 28.33       56.66      TRUE
#> 3    3   56.66    34.66 51.99 17.33 28.33       84.99      TRUE
#> 4    4   84.99    51.99 69.32 17.33 28.33      113.32      TRUE
#> 5    5  113.32    69.32 86.65 17.33    NA          NA     FALSE
plot(geometry)

```
