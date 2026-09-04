# Convert stair geometry into a plotting scene

Creates a stair_scene from a rendered stair layout. The layout should
normally be created with
[`compute_geom_layout()`](https://clement-lvd.github.io/stairtools/reference/compute_geom_layout.md)
when construction parameters such as nosing or tread thickness must be
represented.

## Usage

``` r
geometry_to_scene(layout)
```

## Arguments

- layout:

  A rendered stair layout returned by
  [`compute_geom_layout()`](https://clement-lvd.github.io/stairtools/reference/compute_geom_layout.md)
  or a compatible `stair_geometry` object.

## Value

A `stair_scene` object.

## Examples

``` r
geometry <- build_geometry( n_risers = 5, step_height = 17.33, goings = rep(28.33, 4))
layout <- compute_geom_layout(  geometry,  nosing = 3,  tread_thickness = 4)
scene <- geometry_to_scene(layout)
plot(scene)

```
