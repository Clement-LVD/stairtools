# Add stair comfort indicators

Computes derived geometric indicators related to stair comfort from
stair solutions. The function adds the rise-to-going ratio, a comfort
class, the stair slope in degrees, and deviations from dimensions
associated with public preference.

## Usage

``` r
add_stair_comfort_values(x, .verbose = TRUE)
```

## Arguments

- x:

  A `data.frame` containing `step_rise` and `going` columns, such as an
  object returned by
  [`solve_stairs()`](https://clement-lvd.github.io/stairtools/reference/solve_stairs.md).

- .verbose:

  `logical` - Display message if `TRUE`.

## Value

The input `data.frame` with the following additional columns:

- slope_angle:

  Stair slope in degrees.

- acceptable_slope_angle:

  `TRUE` if the slope is within 17-48 degrees.

- rise_going_ratio:

  Ratio of riser height to going (H/G).

- comfort:

  Stair comfort class, according to the French norms (NF DTU 36.3):
  `comfortable`, `normal`, `steep`, or `uncomfortable`.

- rise_preference_deviation:

  Signed deviation of the riser from 183 mm.

- going_preference_deviation:

  Signed deviation from the preferred going interval of 279–300 mm.
  Values within the interval have a deviation of zero.

## Details

**Comfort classes.** Comfort classes are based on the classification
given in NF DTU 36.3:

- comfortable: H/G \< 0.78;

- normal: 0.78 \<= H/G \< 1;

- steep: 1 \<= H/G \< 1.32;

- `NA` when H/G \>= 1.32.

The slope angle is calculated as `atan(H/G)` and expressed in degrees.

**Acceptable slope.** The "normally accepted range for stairs" is 17-48
degrees (Templer, 192, p. 33).

**Public preference.** According to Irvine et al. (1990, p. 215), "the
optimum riser was 7·2 in (183 mm), and the optimum tread (run) was 11 or
12 in (279 or 300 mm)".

The deviation from the preferred riser is calculated relative to 183 mm.
For the going, the interval 279–300 mm is considered the preferred
interval: values within this interval have a deviation of zero, while
values below or above it are measured from the corresponding bound.

## References

AFNOR. NF DTU 36.3, Escaliers en bois et garde-corps associés.

Templer, John A. The Staircase: Studies of Hazards, Falls, and Safer
Design. 2. print. MIT Press, 1992.
https://doi.org/10.7551/mitpress/6434.001.0001.

Irvine, C. H., Snook, S. H., & Sparshatt, S. H. (1990). Stairway risers
and treads: acceptable and preferred dimensions. *Applied Ergonomics*,
21(3), 215–225.
[doi:10.1016/0003-6870(90)90005-I](https://doi.org/10.1016/0003-6870%2890%2990005-I)

## Examples

``` r
x <- data.frame(step_rise = c(16, 18, 20), going = c(25, 28, 31))

add_stair_comfort_values(x)
#> Adding comfort variables:  slope_angle, acceptable_slope_angle, rise_going_ratio, comfort, rise_preference_deviation, going_preference_deviation
#>   step_rise going slope_angle acceptable_slope_angle rise_going_ratio
#> 1        16    25    32.61924                   TRUE        0.6400000
#> 2        18    28    32.73523                   TRUE        0.6428571
#> 3        20    31    32.82854                   TRUE        0.6451613
#>       comfort rise_preference_deviation going_preference_deviation
#> 1 comfortable                      -2.3                       -2.9
#> 2 comfortable                      -0.3                        0.0
#> 3 comfortable                       1.7                        1.0
```
