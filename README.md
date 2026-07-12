
<!-- README.md is generated from README.Rmd. Please edit that file -->

# stairtools

<!-- badges: start -->

<!-- badges: end -->

stairtools provides tools to compute and visualize straight stair
geometries from basic architectural constraints.

The package separates the calculation into three main steps:

1.  stair rise: determines the number of rises and the riser height from
    the total height.
2.  stair run: computes the horizontal development of the flight.
3.  stair geometry: builds the complete stepped profile.

## Design principle

The main function is `stair_compute()`, which combines these steps into
a complete stair solution.

`max_run` represents the maximum available horizontal space, not a
length that must be fully occupied. If this maximum theoretical value
indicated does not fit in the available space, it is reduced
accordingly. This means that a large available length does not
automatically produce a longer stair: the unused space remains
available.

The stair geometry follows the Blondel - comfort - relationship:

$$2r + g = B$$

where $r$ is the riser height, $g$ is the tread depth (going), and $B$
is the target Blondel value.

## Installation

Install the development version from GitHub:

``` r
# install.packages("remotes")

remotes::install_github("clement-LVD/stairtools")
```

``` r

library(stairtools)

s <- stair_compute(height = 840, max_run = 1040)

plot(s$geometry)
```

![](README_files/figure-gfm/examples-1.png)<!-- -->

The returned object contains:

- s\$rise : vertical stair calculation
- s\$build : horizontal stair calculation
- s\$geometry : complete stair profile
- s\$unused_run : remaining available horizontal space

The plot displays:

- the stepped profile,
- departure and arrival reference levels,
- cumulative horizontal dimensions,
- cumulative vertical dimensions.

``` r

s <- stair_compute(
  height = 3000,
  max_run = 6000,
  start = landing(depth = 1200),
  end = landing(depth = 1000)
)

s
#> $height
#> [1] 3000
#> 
#> $max_run
#> [1] 6000
#> 
#> $unused_run
#> [1] 0
#> 
#> $start
#> $type
#> [1] "none"
#> 
#> $depth
#> [1] 1200
#> 
#> $units
#> [1] "mm"
#> 
#> attr(,"class")
#> [1] "landing"
#> 
#> $end
#> $type
#> [1] "none"
#> 
#> $depth
#> [1] 1000
#> 
#> $units
#> [1] "mm"
#> 
#> attr(,"class")
#> [1] "landing"
#> 
#> $rise
#> Stair rise calculation
#> 
#> Height : 3000 mm
#> Number of rises : 18 
#> Rise : 166.7 mm
#> 
#> $build
#> Stair run calculation
#> 
#> Number of rises : 18 
#> Number of treads : 17 
#> Going : 223.5294 mm
#> Stair flight run : 3800 mm
#> Total length : 6000 mm
#> 
#> $geometry
#> Stair geometry
#> 
#> Height : 3000 mm
#> Number of rises : 18 
#> Rise : 166.6667 mm
#> Going : 223.5294 mm
#> Blondel : 556.9 mm
#> 
#>    level         x    height    depth    type
#> 1      0    0.0000    0.0000   0.0000   floor
#> 2      1  223.5294  166.6667 223.5294   tread
#> 3      2  447.0588  333.3333 223.5294   tread
#> 4      3  670.5882  500.0000 223.5294   tread
#> 5      4  894.1176  666.6667 223.5294   tread
#> 6      5 1117.6471  833.3333 223.5294   tread
#> 7      6 1341.1765 1000.0000 223.5294   tread
#> 8      7 1564.7059 1166.6667 223.5294   tread
#> 9      8 1788.2353 1333.3333 223.5294   tread
#> 10     9 2011.7647 1500.0000 223.5294   tread
#> 11    10 2235.2941 1666.6667 223.5294   tread
#> 12    11 2458.8235 1833.3333 223.5294   tread
#> 13    12 2682.3529 2000.0000 223.5294   tread
#> 14    13 2905.8824 2166.6667 223.5294   tread
#> 15    14 3129.4118 2333.3333 223.5294   tread
#> 16    15 3352.9412 2500.0000 223.5294   tread
#> 17    16 3576.4706 2666.6667 223.5294   tread
#> 18    17 3800.0000 2833.3333 223.5294   tread
#> 19    18 3800.0000 3000.0000   0.0000 arrival
#> 
#> $constraints
#> $constraints$blondel_target
#> [1] 630
#> 
#> $constraints$min_going
#> [1] 150
#> 
#> $constraints$max_going
#> [1] 350
#> 
#> 
#> attr(,"class")
#> [1] "stair_solution"
```

## Constraints

The computation accepts optional limits:

``` r

s <- stair_compute(
  height = 3000,
  max_run = 6000,
  start = landing(depth = 1200),
  end = landing(depth = 1000)
)

s 
#> $height
#> [1] 3000
#> 
#> $max_run
#> [1] 6000
#> 
#> $unused_run
#> [1] 0
#> 
#> $start
#> $type
#> [1] "none"
#> 
#> $depth
#> [1] 1200
#> 
#> $units
#> [1] "mm"
#> 
#> attr(,"class")
#> [1] "landing"
#> 
#> $end
#> $type
#> [1] "none"
#> 
#> $depth
#> [1] 1000
#> 
#> $units
#> [1] "mm"
#> 
#> attr(,"class")
#> [1] "landing"
#> 
#> $rise
#> Stair rise calculation
#> 
#> Height : 3000 mm
#> Number of rises : 18 
#> Rise : 166.7 mm
#> 
#> $build
#> Stair run calculation
#> 
#> Number of rises : 18 
#> Number of treads : 17 
#> Going : 223.5294 mm
#> Stair flight run : 3800 mm
#> Total length : 6000 mm
#> 
#> $geometry
#> Stair geometry
#> 
#> Height : 3000 mm
#> Number of rises : 18 
#> Rise : 166.6667 mm
#> Going : 223.5294 mm
#> Blondel : 556.9 mm
#> 
#>    level         x    height    depth    type
#> 1      0    0.0000    0.0000   0.0000   floor
#> 2      1  223.5294  166.6667 223.5294   tread
#> 3      2  447.0588  333.3333 223.5294   tread
#> 4      3  670.5882  500.0000 223.5294   tread
#> 5      4  894.1176  666.6667 223.5294   tread
#> 6      5 1117.6471  833.3333 223.5294   tread
#> 7      6 1341.1765 1000.0000 223.5294   tread
#> 8      7 1564.7059 1166.6667 223.5294   tread
#> 9      8 1788.2353 1333.3333 223.5294   tread
#> 10     9 2011.7647 1500.0000 223.5294   tread
#> 11    10 2235.2941 1666.6667 223.5294   tread
#> 12    11 2458.8235 1833.3333 223.5294   tread
#> 13    12 2682.3529 2000.0000 223.5294   tread
#> 14    13 2905.8824 2166.6667 223.5294   tread
#> 15    14 3129.4118 2333.3333 223.5294   tread
#> 16    15 3352.9412 2500.0000 223.5294   tread
#> 17    16 3576.4706 2666.6667 223.5294   tread
#> 18    17 3800.0000 2833.3333 223.5294   tread
#> 19    18 3800.0000 3000.0000   0.0000 arrival
#> 
#> $constraints
#> $constraints$blondel_target
#> [1] 630
#> 
#> $constraints$min_going
#> [1] 150
#> 
#> $constraints$max_going
#> [1] 350
#> 
#> 
#> attr(,"class")
#> [1] "stair_solution"
```

Where:

- blondel_target controls the preferred comfort relationship,
- min_going prevents unrealistic very small treads,
- max_going limits excessively deep treads.

## Units

All dimensions are expressed in millimetres.
