# Generate possible going scenarios for a given number of steps

For a given `n_steps` and its Blondel `going`, systematically generates
5 going scenarios without favoring any of them (the choice is made
later, by comparing `blondel_target_deviation` and `horizontal_run`
across scenarios):

## Usage

``` r
generate_going_scenarios(n_steps, max_horizontal_run, going)
```

## Arguments

- n_steps:

  Number of risers.

- max_horizontal_run:

  Available horizontal distance (cm).

- going:

  Going from
  [`blondel_going`](https://clement-lvd.github.io/stairtools/reference/blondel_going.md)
  (cm).

## Value

A named list of 5 scenarios (empty list if `n_steps <= 1`). Each
scenario contains: `goings`, `going_type`, `horizontal_run`,
`blondel_target_deviation` (mean absolute gap to the standard going,
standard goings only), `has_landing`, and depending on the case
`horizontal_run_exceeded` and/or `landing_impossible`.

## Details

- no_landing_blondel:

  Standard (Blondel) goings, no landing step. The last riser lands
  directly on the landing.

- no_landing_uniform:

  A uniform going = `max_horizontal_run / n_goings`, ignoring Blondel,
  to fill the whole space with no landing step.

- landing_standard:

  Standard goings + a landing step (after the last riser, at landing
  level), also at the standard going: leftover space may remain.

- landing_max:

  Standard goings + a landing step that absorbs all remaining space
  (potentially very large going: filling an opening, giant landing step
  in front of a door, etc.).

- landing_uniform:

  A uniform going = `max_horizontal_run / n_steps`, applied to all steps
  including the landing step.

In every "with landing" scenario, the landing step is the last one,
positioned after the last riser, at the same height as the finished
floor on arrival — never followed by a riser.

`blondel_target_deviation` only covers goings of type "standard": the
landing step's going is excluded from the calculation, since the foot is
already at finished floor level there (its value doesn't affect the
comfort of the climb).

If the space doesn't allow a scenario (zero or negative landing going),
it is still returned, with `landing_impossible = TRUE` and/or
`horizontal_run_exceeded = TRUE`: nothing is hidden, everything is left
for later comparison.

## Examples

``` r
going <- blondel_going(16.25)  # 30.5
scenarios <- generate_going_scenarios(n_steps = 16, max_horizontal_run = 450,
                                      going = going)
names(scenarios)
#> [1] "no_landing_blondel" "no_landing_uniform" "landing_standard"  
#> [4] "landing_max"        "landing_uniform"   
scenarios$landing_max$blondel_target_deviation  # 0: the giant landing step doesn't count
#> [1] 0
```
