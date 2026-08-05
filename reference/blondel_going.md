# Compute the going from Blondel's formula

Applies Blondel's formula: `2 * rise + going = blondel_target` to
compute the corresponding going.

## Usage

``` r
blondel_going(rise, blondel_target = 63)
```

## Arguments

- rise:

  `numeric` - Riser height (cm).

- blondel_target:

  `numeric` - Target value of Blondel's formula `2h + g` (cm). Default:
  63.

## Value

Return a `numeric` with the computed going length (cm).

## Details

The default target value is 63 cm, which corresponds to a commonly used
comfortable stair proportion.

## Examples

``` r
blondel_going(16.25)  # 30.5
#> [1] 30.5
blondel_going(20)     # 23
#> [1] 23
```
