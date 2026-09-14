# Create a polygon drawing instruction

Basic converting of 2 vectors and a `step` column into a polygon list
structure

## Usage

``` r
.create_polygon(data, i, x, y)
```

## Arguments

- data:

  `data.frame` containing polygon coordinates.

- i:

  Row index.

- x:

  Character vector of x coordinate column names.

- y:

  Character vector of y coordinate column names.

## Value

A polygon drawing instruction.
