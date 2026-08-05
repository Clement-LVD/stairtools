# Determine feasible numbers of risers (vertical element between steps) for a given total height

Computes all feasible numbers of steps for a specified total height,
according to the minimum and maximum allowable riser heights.

## Usage

``` r
optimal_nrisers(total_height, rise_min = 16, rise_max = 20, rise_target = 16)
```

## Arguments

- total_height:

  `numeric` - Total vertical height to climb (cm).

- rise_min:

  `numeric` - Minimum acceptable riser height (cm). Default: 16.

- rise_max:

  `numeric` - Maximum acceptable riser height (cm). Default: 20.

- rise_target:

  `numeric` - Target riser height used to rank solutions (cm). Default:
  16.

## Value

Return a `data.frame` with one row per feasible solution. The returned
data frame contains the following columns:

- n_risers:

  Number of risers.

- rise:

  Computed riser height (cm).

- rise_target_deviation:

  Absolute deviation from the target riser height (cm).

Rows are ordered by increasing `rise_target_deviation`.

## Details

For each feasible solution, the corresponding riser height and its
absolute deviation from the target riser height are computed. Solutions
are returned in ascending order of deviation, so the first row
corresponds to the riser height closest to the target.

## Examples

``` r
optimal_nrisers(total_height = 260)
#>   n_risers     rise rise_target_deviation
#> 4       16 16.25000              0.250000
#> 3       15 17.33333              1.333333
#> 2       14 18.57143              2.571429
#> 1       13 20.00000              4.000000
```
