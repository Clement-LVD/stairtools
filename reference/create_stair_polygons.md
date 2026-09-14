# Create stair polygon drawing instructions

Converts stair geometry into polygon drawing instructions.

## Usage

``` r
create_stair_polygons(geometry, riser = TRUE)
```

## Arguments

- geometry:

  `stair_geometry` data frame : columns names are hardcoded hereafter,
  in order to convert geometry into a polygon list of coordinates.

- riser:

  Logical; whether to include riser polygons.

## Value

A list of polygon drawing instructions.
