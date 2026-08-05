# Plot a stair profile with dimensions

Shortcut for `plot_stair(..., show_dimensions = TRUE)`.

## Usage

``` r
plot_stair_dimensions(geometry, ...)
```

## Arguments

- geometry:

  A stair geometry data frame returned by
  [`build_geometry`](https://clement-lvd.github.io/stairtools/reference/build_geometry.md).

- ...:

  Additional arguments passed to
  [`plot_stair`](https://clement-lvd.github.io/stairtools/reference/plot_stair.md).

## Examples

``` r
geometry <- build_geometry(5, 17.33, rep(28.33, 4))
plot_stair_dimensions(geometry)

```
