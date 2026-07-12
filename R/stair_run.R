#' Calculate stair horizontal geometry
#'
#' @param n_rises Number of vertical rises.
#' @param going Tread depth.
#' @param start Start landing object.
#' @param end End landing object.
#'
#' @return Object of class "stair_run".
#'
#' @export
stair_run <- function(
    n_rises,
    going,
    start = landing(),
    end = landing()
) {
  
  
  if (!inherits(start,"landing"))
    stop("start must be a landing")
  
  
  if (!inherits(end,"landing"))
    stop("end must be a landing")
  
  
  # A normal flight has one less tread than rises
  n_treads <- n_rises - 1
  
  
  flight_run <-
    n_treads * going
  
  
  overall_run <-
    flight_run +
    start$depth +
    end$depth
  
  
  structure(
    list(
      n_rises = n_rises,
      n_treads = n_treads,
      going = going,
      flight_run = flight_run,
      overall_run = overall_run,
      start = start,
      end = end,
      units = "mm"
    ),
    class = "stair_run"
  )
}