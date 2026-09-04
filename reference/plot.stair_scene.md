# Plot a stair scene

Styling only happens here – building the scene has zero plotting cost.

## Usage

``` r
# S3 method for class 'stair_scene'
plot(x, theme = list(), ...)
```

## Arguments

- x:

  A `stair_scene`.

- theme:

  A named list of per-role styles, merged over
  [`theme_default()`](https://clement-lvd.github.io/stairtools/reference/theme_default.md).

- ...:

  Passed to the underlying
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html) call.
