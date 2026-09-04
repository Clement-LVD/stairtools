# Add riser segments to a stair scene

Creates one vertical segment per riser using the rendered riser
coordinates.

## Usage

``` r
scene_add_risers(scene, layout)
```

## Arguments

- scene:

  A `stair_scene`.

- layout:

  A rendered geometry returned by
  [`compute_geom_layout()`](https://clement-lvd.github.io/stairtools/reference/compute_geom_layout.md).

## Value

The modified scene.
