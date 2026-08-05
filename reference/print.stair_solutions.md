# Print stair solutions without the geometry list-column

The `geometry` column contains complete geometry data frames. Displaying
it directly would make the output difficult to read. This print method
hides the `geometry` column while keeping it fully accessible through
`$geometry`.

## Usage

``` r
# S3 method for class 'stair_solutions'
print(x, ...)
```

## Arguments

- x:

  A `stair_solutions` object.

- ...:

  Additional arguments passed to
  [`print.data.frame()`](https://rdrr.io/r/base/print.dataframe.html).
