# Compute the rendered stair profile from a stair geometry

Converts a theoretical stair geometry into a rendered profile. The input
`going` values are measured nose-to-nose. Nosing therefore shifts the
visible riser position, while tread thickness reduces the visible height
of the riser.

## Usage

``` r
compute_geom_layout(geometry, nosing = 0, tread_thickness = 0)
```

## Arguments

- geometry:

  A `stair_geometry` object returned by
  [`build_geometry()`](https://clement-lvd.github.io/stairtools/reference/build_geometry.md).

- nosing:

  Nosing length, in cm. Default is `0`.

- tread_thickness:

  Tread thickness, in cm. Default is `0`.

## Value

A data frame with additional columns: `riser_x` and `riser_top_y`.

## Details

The original geometry is not modified.
