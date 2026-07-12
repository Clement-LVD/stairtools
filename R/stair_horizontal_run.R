#' Calculate stair horizontal geometry
#'
#' Calculates tread count, flight length and total horizontal occupation.
#'
#' @param n_rises `numeric` - Number of vertical rises.
#' @param going `numeric` - Tread depth in mm.
#' @param start A `landing` object representing the starting landing.
#' @param end A `landing` object representing the ending landing.
#'
#' @return An object of class "stair_run".
#'
#' @export
stair_horizontal_run <- function(
    n_rises,
    going,
    start = landing(),
    end = landing()
) {

  check_numeric(n_rises, "n_rises")
  check_numeric(going, "going")

  if (n_rises < 2 || n_rises != floor(n_rises))
    stop("n_rises must be an integer greater than or equal to 2")

  if (going <= 0)
    stop("going must be positive")

  if (!inherits(start, "landing"))
    stop("start must be a landing")

  if (!inherits(end, "landing"))
    stop("end must be a landing")


  n_treads <- n_rises - 1

  flight_run <- n_treads * going

  overall_run <- start$depth +  flight_run +  end$depth


  structure(
    list(
      n_rises = n_rises 
      , n_treads = n_treads 
      , going = going 
      , flight_run = flight_run 
      , overall_run = overall_run 
      , start = start 
      , end = end 
      , units = "mm"
    ),
    class = "stair_run"
  )
}


#' @export
#' @method print stair_run
print.stair_run <- function(x, ...) {

  cat("Stair run calculation\n\n")

  cat("Number of rises :", x$n_rises, "\n")
  cat("Number of treads :", x$n_treads, "\n")
  cat("Going :", x$going, "mm\n")

  cat( "Stair flight run :", x$flight_run, "mm\n" )

  cat("Total length :", x$overall_run,   "mm\n" )

  invisible(x)
}