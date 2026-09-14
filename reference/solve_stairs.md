# Compute all possible stair solutions

Main function of the package. Generates all feasible stair geometries
matching the specified constraints without selecting a preferred
solution.

## Usage

``` r
solve_stairs(
  total_height,
  max_horizontal_run,
  nosing = 0,
  rise_min = 16,
  rise_max = 20,
  rise_target = 16,
  blondel_target = 63,
  positive_nosing_direction = TRUE,
  tread_thickness = 0,
  riser_thickness = 0,
  show_invalid_solutions = FALSE,
  check_stair_rules = FALSE
)
```

## Arguments

- total_height:

  `numeric` - Total vertical height to climb (cm).

- max_horizontal_run:

  `numeric` - Maximum available horizontal length (cm).

- nosing:

  `numeric` - length of the nosing extension. Must be non-negative and
  use the same units as `geometry`.

- rise_min:

  `numeric` - Minimum acceptable step height (cm). Default: 16.

- rise_max:

  `numeric` - Maximum acceptable step height (cm). Default: 20.

- rise_target:

  `numeric` - Target step height used to rank solutions (cm). Default:
  16.

- blondel_target:

  `numeric` - Target value for Blondel's formula `2h + g`. Default: 63
  cm.

- positive_nosing_direction:

  `logical` - If `TRUE`, the nosing extends toward the positive x-axis.
  If `FALSE`, it extends toward the negative x-axis.

- tread_thickness:

  `numeric` - Tread thickness (cm). Defaults to `0`.

- riser_thickness:

  `numeric` - Riser thickness (cm). Defaults to `0`.

- show_invalid_solutions:

  `logical` - If `TRUE`, returns all generated solutions, including
  solutions that do not satisfy the constraints. Default: `FALSE`.

- check_stair_rules:

  `logical` - If `TRUE`, returns additional columns relating to legal
  compliance and compliance with academic standards.

## Value

A `data.frame` containing one row per generated solution. Geometry is
stored in the `geometry` list-column.

## Details

For each valid number of steps, possible tread values are generated and
complete stair geometries are computed. All solutions are returned in a
single data frame, with geometry stored as a list-column.

## Examples

``` r
sol <- solve_stairs(total_height = 160, max_horizontal_run = 150)
# default is a concrete floor with no nosing
sol
#> 
#>   3 valid solution(s)
#>    n_risers step_rise rise_target_deviation    going           scenario
#> 10        8  20.00000              4.000000 23.00000 no_landing_uniform
#> 6         9  17.77778              1.777778 27.44444 no_landing_uniform
#> 2        10  16.00000              0.000000 31.00000 no_landing_uniform
#>    horizontal_run  blondel blondel_target_deviation has_landing
#> 10            150 61.42857                 1.571429       FALSE
#> 6             150 54.30556                 8.694444       FALSE
#> 2             150 48.66667                14.333333       FALSE
#>    horizontal_run_exceeded landing_impossible is_valid rank
#> 10                   FALSE              FALSE     TRUE    1
#> 6                    FALSE              FALSE     TRUE    2
#> 2                    FALSE              FALSE     TRUE    3
#> ('geometry' list-col is hidden - access via $geometry[[i]])

plot(sol$geometry[[1]])


# wood stair
sol2 <- solve_stairs(total_height = 160, max_horizontal_run = 230, tread_thickness = 4, nosing = 4)
#' # Filter out solution with a landing 
sol2 <- subset(sol2, has_landing)
plot_stair(sol2$geometry[[1]])


# Or get all the solutions, even if state-of-the-art will not be respected
 sol3 <- solve_stairs(160, 150, show_invalid_solutions = TRUE)

# Filter out valid solution
subset(sol3, is_valid)
#> 
#>   3 valid solution(s)
#>    n_risers step_rise rise_target_deviation    going           scenario
#> 10        8  20.00000              4.000000 23.00000 no_landing_uniform
#> 6         9  17.77778              1.777778 27.44444 no_landing_uniform
#> 2        10  16.00000              0.000000 31.00000 no_landing_uniform
#>    horizontal_run  blondel blondel_target_deviation has_landing
#> 10            150 61.42857                 1.571429       FALSE
#> 6             150 54.30556                 8.694444       FALSE
#> 2             150 48.66667                14.333333       FALSE
#>    horizontal_run_exceeded landing_impossible is_valid rank
#> 10                   FALSE              FALSE     TRUE    1
#> 6                    FALSE              FALSE     TRUE    2
#> 2                    FALSE              FALSE     TRUE    3
#> ('geometry' list-col is hidden - access via $geometry[[i]])
```
