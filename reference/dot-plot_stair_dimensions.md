# Plot stair dimensions

Adds cumulative horizontal and vertical dimensions to a stair profile.

## Usage

``` r
.plot_stair_dimensions(geometry, cex_dimensions = 0.8)
```

## Arguments

- geometry:

  A stair geometry data frame.

- cex_dimensions:

  Character expansion factor for labels.

## Details

This is a helper function used by
[`plot_stair`](https://clement-lvd.github.io/stairtools/reference/plot_stair.md)
when `show_dimensions = TRUE`.
