
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

str(s)
#> List of 9
#>  $ height     : num 3000
#>  $ max_run    : num 6000
#>  $ unused_run : num 0
#>  $ start      :List of 3
#>   ..$ type : chr "none"
#>   ..$ depth: num 1200
#>   ..$ units: chr "mm"
#>   ..- attr(*, "class")= chr "landing"
#>  $ end        :List of 3
#>   ..$ type : chr "none"
#>   ..$ depth: num 1000
#>   ..$ units: chr "mm"
#>   ..- attr(*, "class")= chr "landing"
#>  $ rise       :List of 10
#>   ..$ height        : num 3000
#>   ..$ n_rises       : int 18
#>   ..$ rise          : num 167
#>   ..$ score         : num 6.67
#>   ..$ candidates    :'data.frame':   4 obs. of  3 variables:
#>   .. ..$ n_rises: int [1:4] 18 17 16 15
#>   .. ..$ rise   : num [1:4] 167 176 188 200
#>   .. ..$ score  : num [1:4] 6.67 16.47 27.5 40
#>   ..$ target_rise   : num 160
#>   ..$ min_rise      : num 160
#>   ..$ max_rise      : num 200
#>   ..$ units         : chr "mm"
#>   ..$ found_solution: logi TRUE
#>   ..- attr(*, "class")= chr "stair_rise"
#>  $ build      :List of 8
#>   ..$ n_rises    : int 18
#>   ..$ n_treads   : num 17
#>   ..$ going      : num 224
#>   ..$ flight_run : num 3800
#>   ..$ overall_run: num 6000
#>   ..$ start      :List of 3
#>   .. ..$ type : chr "none"
#>   .. ..$ depth: num 1200
#>   .. ..$ units: chr "mm"
#>   .. ..- attr(*, "class")= chr "landing"
#>   ..$ end        :List of 3
#>   .. ..$ type : chr "none"
#>   .. ..$ depth: num 1000
#>   .. ..$ units: chr "mm"
#>   .. ..- attr(*, "class")= chr "landing"
#>   ..$ units      : chr "mm"
#>   ..- attr(*, "class")= chr "stair_run"
#>  $ geometry   :List of 14
#>   ..$ profile             :'data.frame': 35 obs. of  2 variables:
#>   .. ..$ x: num [1:35] 0 224 224 447 447 ...
#>   .. ..$ y: num [1:35] 167 167 333 333 500 ...
#>   ..$ steps               :'data.frame': 19 obs. of  5 variables:
#>   .. ..$ level : num [1:19] 0 1 2 3 4 5 6 7 8 9 ...
#>   .. ..$ x     : num [1:19] 0 224 447 671 894 ...
#>   .. ..$ height: num [1:19] 0 167 333 500 667 ...
#>   .. ..$ depth : num [1:19] 0 224 224 224 224 ...
#>   .. ..$ type  : chr [1:19] "floor" "tread" "tread" "tread" ...
#>   ..$ height              : num 3000
#>   ..$ n_rises             : int 18
#>   ..$ rise                : num 167
#>   ..$ going               : num 224
#>   ..$ flight_run          : num 3800
#>   ..$ overall_run         : num 6000
#>   ..$ blondel             : num 557
#>   ..$ first_step_is_floor : logi FALSE
#>   ..$ last_step_is_landing: logi FALSE
#>   ..$ start               :List of 3
#>   .. ..$ type : chr "none"
#>   .. ..$ depth: num 1200
#>   .. ..$ units: chr "mm"
#>   .. ..- attr(*, "class")= chr "landing"
#>   ..$ end                 :List of 3
#>   .. ..$ type : chr "none"
#>   .. ..$ depth: num 1000
#>   .. ..$ units: chr "mm"
#>   .. ..- attr(*, "class")= chr "landing"
#>   ..$ units               : chr "mm"
#>   ..- attr(*, "class")= chr "stair_geometry"
#>  $ constraints:List of 3
#>   ..$ blondel_target: num 630
#>   ..$ min_going     : num 150
#>   ..$ max_going     : num 350
#>  - attr(*, "class")= chr "stair_solution"
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
 
```

Where:

- blondel_target controls the preferred comfort relationship,
- min_going prevents unrealistic very small treads,
- max_going limits excessively deep treads.

## Units

All dimensions are expressed in millimetres.
