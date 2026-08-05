# Check stair solutions against dimensional rules

Checks stair solutions against rules stored in `stair_rules`.

## Usage

``` r
check_stair_rules(x, rule = NULL)
```

## Arguments

- x:

  A `data.frame` of stair solutions.

- rule:

  `character` - Optional rule id. If `NULL`, all rules are checked.

## Value

Return the input `data.frame` with one logical column per rule.

## Examples

``` r
sol <- solve_stairs(160, 150)
check_stair_rules(sol)
#> 
#>   6 valid solution(s)
#>    n_risers step_rise rise_target_deviation    going           scenario
#> 12        8  20.00000              4.000000 23.00000 no_landing_uniform
#> 15        8  20.00000              4.000000 23.00000    landing_uniform
#> 7         9  17.77778              1.777778 27.44444 no_landing_uniform
#> 10        9  17.77778              1.777778 27.44444    landing_uniform
#> 2        10  16.00000              0.000000 31.00000 no_landing_uniform
#> 5        10  16.00000              0.000000 31.00000    landing_uniform
#>    horizontal_run  blondel blondel_target_deviation has_landing
#> 12            150 61.42857                 1.571429       FALSE
#> 15            150 58.75000                 4.250000        TRUE
#> 7             150 54.30556                 8.694444       FALSE
#> 10            150 52.22222                10.777778        TRUE
#> 2             150 48.66667                14.333333       FALSE
#> 5             150 47.00000                16.000000        TRUE
#>    horizontal_run_exceeded landing_impossible is_valid rank
#> 12                   FALSE              FALSE     TRUE    1
#> 15                   FALSE              FALSE     TRUE    2
#> 7                    FALSE              FALSE     TRUE    3
#> 10                   FALSE              FALSE     TRUE    4
#> 2                    FALSE              FALSE     TRUE    5
#> 5                    FALSE              FALSE     TRUE    6
#>    habitation_common_areas habitation_dwellings access_public_building
#> 12                   FALSE                FALSE                  FALSE
#> 15                   FALSE                FALSE                  FALSE
#> 7                    FALSE                 TRUE                  FALSE
#> 10                   FALSE                 TRUE                  FALSE
#> 2                     TRUE                 TRUE                   TRUE
#> 5                     TRUE                 TRUE                   TRUE
#>    workplace_accessibility erp_public_stairs machinery_access private_uk
#> 12                   FALSE              TRUE             TRUE       TRUE
#> 15                   FALSE              TRUE             TRUE       TRUE
#> 7                    FALSE              TRUE             TRUE       TRUE
#> 10                   FALSE              TRUE             TRUE       TRUE
#> 2                     TRUE              TRUE             TRUE       TRUE
#> 5                     TRUE              TRUE             TRUE       TRUE
#>    utility_uk general_access_uk
#> 12       TRUE              TRUE
#> 15       TRUE              TRUE
#> 7        TRUE              TRUE
#> 10       TRUE              TRUE
#> 2        TRUE              TRUE
#> 5        TRUE              TRUE
#> ('geometry' list-col is hidden - access via $geometry[[i]])
```
