#' Compute the going from Blondel's formula
#'
#' Applies Blondel's formula:
#' \code{2 * rise + going = blondel_target}
#' to compute the corresponding going.
#'
#' The default target value is 63 cm, which corresponds to a commonly used
#' comfortable stair proportion.
#'
#' @param rise `numeric` - Riser height (cm).
#' @param blondel_target `numeric` - Target value of Blondel's formula
#'   \code{2h + g} (cm). Default: 63.
#'
#' @return Return a `numeric` with the computed going length (cm).
#'
#' @examples
#' blondel_going(16.25)  # 30.5
#' blondel_going(20)     # 23
#'
#' @export
blondel_going <- function(rise, blondel_target = 63) {

  rise <- abs(rise)

  going <- blondel_target - 2 * rise

  if (any(going <= 0)) {
    warning(
      "Computed going is zero or negative: rise is too large for the selected Blondel target."
    )
  }

  going
}
