# Compute fine stair geometry

Adds the coordinates required to represent tread and riser thickness.
Physical tread and riser positions are taken from the surface geometry.

## Usage

``` r
compute_geom_fine(geometry, tread_thickness = 0, riser_thickness = 0)
```

## Arguments

- geometry:

  A stair geometry data frame containing physical surface coordinates.

- tread_thickness:

  Thickness of the tread.

- riser_thickness:

  Thickness of the riser.

## Value

The geometry with `riser_top_y` and `x_riser_end` columns.

## Examples

``` r
if (FALSE) { # \dontrun{
geometry <- add_stair_surface_geometry( build_geometry( n_risers = 5, step_height = 17.33, goings = rep(28.33, 4) ),
nosing = 4, nosing_direction = "negative" )

g <- compute_geom_fine( geometry, tread_thickness = 4, riser_thickness = 3 )
} # }
```
