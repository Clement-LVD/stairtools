#' Create a stair landing object
#'
#' A landing is a horizontal walking surface that does not create a
#' vertical rise. It can be located at the beginning, end or between
#' stair flights.
#'
#' @param depth `numeric` - Horizontal depth of the landing in mm.
#' @param type `character` - Landing position:
#'   "none", "start", "end", "intermediate".
#'
#' @return An object of class "landing".
#'
#' @export
landing <- function(
    depth = 0,
    type = c(
      "none",
      "start",
      "end",
      "intermediate"
    )
) {
  check_numeric(depth, "depth")

  
  if (depth < 0) stop("depth must be positive")
  
    type <- match.arg(type)

  structure(
    list(
      type = type,
      depth = depth,
      units = "mm"
    ),
    class = "landing"
  )
}