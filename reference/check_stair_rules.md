# Check stair solutions against dimensional rules

Checks stair solutions against rules stored in `stair_rules` (rules from
`sysdata.rda`).

## Usage

``` r
check_stair_rules(
  x,
  rule = NULL,
  dimensions = c("step_rise", "going", "blondel")
)
```

## Arguments

- x:

  A `data.frame` of stair solutions, e.g., returned by
  [`solve_stairs()`](https://clement-lvd.github.io/stairtools/reference/solve_stairs.md).

- rule:

  `character` - Optional rule id. If `NULL`, all rules are checked.

## Value

The input `data.frame` with one logical column per rule, `n_rules_ok`,
and `rate_rules_ok`.

## Examples

``` r
x <- data.frame(
  step_rise = c(15, 17, 19),
  going = c(30, 28, 25),
  blondel = c(60, 62, 63)
)

check_stair_rules(x)
#>   step_rise going blondel US_ADA_public_stairs US_ADA_pool_stairs
#> 1        15    30      60                 TRUE               TRUE
#> 2        17    28      62                 TRUE               TRUE
#> 3        19    25      63                FALSE              FALSE
#>   US_ADA_pool_transfer_steps US_IBC_means_of_egress US_IBC_dwelling_units
#> 1                      FALSE                   TRUE                  TRUE
#> 2                      FALSE                   TRUE                  TRUE
#> 3                      FALSE                   TRUE                 FALSE
#>   US_IBC_guard_towers_obeservation_stations_and_control_rooms
#> 1                                                        TRUE
#> 2                                                        TRUE
#> 3                                                       FALSE
#>   US_IRC_means_of_egress US_IRC_sleeping_loft
#> 1                   TRUE                FALSE
#> 2                   TRUE                FALSE
#> 3                  FALSE                 TRUE
#>   FR_collective_housing_common_areas FR_private_dwelling_interior
#> 1                               TRUE                         TRUE
#> 2                               TRUE                         TRUE
#> 3                              FALSE                        FALSE
#>   FR_ERP_accessibility FR_workplace_accessibility FR_public_circulation_stairs
#> 1                 TRUE                       TRUE                        FALSE
#> 2                FALSE                      FALSE                        FALSE
#> 3                FALSE                      FALSE                        FALSE
#>   ISO_machinery_access UK_private UK_utility UK_general_access n_rules_ok
#> 1                 TRUE       TRUE       TRUE              TRUE         14
#> 2                 TRUE       TRUE       TRUE              TRUE         12
#> 3                 TRUE       TRUE       TRUE             FALSE          5
#>   rate_rules_ok
#> 1     0.8235294
#> 2     0.7058824
#> 3     0.2941176
```
