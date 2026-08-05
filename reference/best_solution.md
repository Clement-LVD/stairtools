# Select the best stair solution

Selects the best valid solution from a table of stair solutions. Only
rows where `is_valid` is `TRUE` are considered. Among these, the
solution with the lowest `rank` is returned.

## Usage

``` r
best_solution(solutions)
```

## Arguments

- solutions:

  A `stair_solutions` object returned by
  [`build_solutions_table`](https://clement-lvd.github.io/stairtools/reference/build_solutions_table.md)
  (or `solve_stairs(...)\$solutions`).

## Value

Return a one-row `data.frame` (class `stair_solutions`) corresponding to
the highest-ranked valid solution. Returns `NULL` if no valid solution
exists.

## Details

The corresponding stair geometry can be accessed directly from the
returned row via `$geometry[[1]]`.

## Examples

``` r
sol <- solve_stairs(200, 160)
best <- best_solution(sol)
#> Warning: The best solution does not produce a comfortable staircase (Blondel value outside the recommended 60 <-> 64 cm range).
#> ==> Consider increasing 'max_horizontal_run'.
plot(best$geometry[[1]])

```
