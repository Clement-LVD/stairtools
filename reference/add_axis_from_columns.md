# Add axes from data frame columns

Adds one horizontal axis for each valid data frame column. Each column
is displayed on a separate axis line. Unknown columns are ignored.

## Usage

``` r
add_axis_from_columns(g, columns, ...)
```

## Arguments

- g:

  A data frame containing the values to display.

- columns:

  Character vector of column names. Optional names are used as axis
  titles.

- ...:

  Graphical parameters passed to
  [`graphics::axis()`](https://rdrr.io/r/graphics/axis.html).

## Value

Invisibly returns `g`.
