#' Add stair comfort indicators
#'
#' Computes derived geometric indicators related to stair comfort from stair
#' solutions. The function adds the rise-to-going ratio, a comfort class,
#' the stair slope in degrees, and deviations from dimensions associated
#' with public preference.
#'
#' **Comfort classes.** Comfort classes are based on the classification given
#' in NF DTU 36.3:
#' \itemize{
#'   \item comfortable: H/G < 0.78;
#'   \item normal: 0.78 <= H/G < 1;
#'   \item steep: 1 <= H/G < 1.32;
#'   \item `NA` when H/G >= 1.32.
#' }
#'
#' The slope angle is calculated as `atan(H/G)` and expressed in degrees.
#' 
#' **Acceptable slope.** The "normally accepted range for stairs" is 17-48 degrees (Templer, 192, p. 33). 
#'
#' **Public preference.** According to Irvine et al. (1990, p. 215),
#' "the optimum riser was 7·2 in (183 mm), and the optimum tread (run) was 11 or 12 in (279 or 300 mm)".
#'
#' The deviation from the preferred riser is calculated relative to 183 mm.
#' For the going, the interval 279--300 mm is considered the preferred
#' interval: values within this interval have a deviation of zero, while
#' values below or above it are measured from the corresponding bound.
#'
#' @param x A `data.frame` containing `step_rise` and `going` columns,
#'   such as an object returned by [solve_stairs()].
#' @param .verbose `logical` - Display message if `TRUE`.
#' @return The input `data.frame` with the following additional columns:
#' \describe{
#'   \item{slope_angle}{Stair slope in degrees.}
#'   \item{acceptable_slope_angle}{`TRUE` if the slope is within 17-48 degrees.}
#'   \item{rise_going_ratio}{Ratio of riser height to going (H/G).}
#'   \item{comfort}{Stair comfort class, according to the French norms (NF DTU 36.3): `comfortable`, `normal`, `steep`, or `uncomfortable`.}
#'   \item{rise_preference_deviation}{Signed deviation of the riser from 183 mm.}
#'   \item{going_preference_deviation}{Signed deviation from the preferred
#'     going interval of 279--300 mm. Values within the interval have a
#'     deviation of zero.}
#' }
#'
#' @examples
#' x <- data.frame(step_rise = c(16, 18, 20), going = c(25, 28, 31))
#'
#' add_stair_comfort_values(x)
#'
#' @references
#' AFNOR. NF DTU 36.3, Escaliers en bois et garde-corps associés.
#' 
#' Templer, John A. The Staircase: Studies of Hazards, Falls, and Safer Design. 2. print. MIT Press, 1992. https://doi.org/10.7551/mitpress/6434.001.0001.
#' 
#' Irvine, C. H., Snook, S. H., & Sparshatt, S. H. (1990).
#' Stairway risers and treads: acceptable and preferred dimensions.
#' *Applied Ergonomics*, 21(3), 215--225.
#' \doi{10.1016/0003-6870(90)90005-I}
#'
#' @export
add_stair_comfort_values <- function(x, .verbose = TRUE) {

  if(.verbose){  original_names <- names(x)  }

  if (!all(c("step_rise", "going") %in% names(x))) {
    stop(
      "`x` must contain `step_rise` and `going`.",
      call. = FALSE
    )
  }

  ratio <- x$step_rise / x$going

  x$slope_angle <- atan(ratio) * 180 / pi
  x$acceptable_slope_angle <- x$slope_angle >= 17 & x$slope_angle <= 48    

  x$rise_going_ratio <- ratio

#french DTU values hardcoded
  x$comfort <- cut(
    ratio,
    breaks = c(-Inf, 0.78, 1, 1.32, Inf),
    labels = c("comfortable", "normal", "steep", "uncomfortable"),
    right = FALSE
  )

  x$rise_preference_deviation <- x$step_rise - 18.3

  x$going_preference_deviation <- ifelse(
    x$going < 27.9,
    x$going - 27.9,
    ifelse(
      x$going > 30,
      x$going - 30,
      0
    )
  )

  if(.verbose) { 
    new_names <- names(x) 
    names_added <-  paste0(setdiff( new_names, original_names), collapse = ", ")
    cat("Adding comfort variables: ", names_added)}

  x
} 
