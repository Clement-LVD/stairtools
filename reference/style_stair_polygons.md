# Apply styles to stair polygons

Applies graphical parameters accepted by
[`graphics::polygon()`](https://rdrr.io/r/graphics/polygon.html) to
selected stair polygons. Styles are applied in order, so later styles
override parameters set by earlier styles.

## Usage

``` r
style_stair_polygons(polygons, polygon_params = list(), styles = NULL)
```

## Arguments

- polygons:

  List of polygon drawing instructions.

- polygon_params:

  Named list of default parameters passed to
  [`graphics::polygon()`](https://rdrr.io/r/graphics/polygon.html).

- styles:

  List of style rules. Each rule may contain `steps` and `surface`
  selectors in addition to graphical parameters accepted by
  [`graphics::polygon()`](https://rdrr.io/r/graphics/polygon.html). A
  missing or `NULL` selector matches all polygons.

## Value

The modified polygon list.
