#' Compute complete stair geometry
#'
#' Calculates a stair geometry fitted to available horizontal space.
#'
#' @param height `numeric` - Total height to overcome in mm.
#' @param max_run `numeric` - Maximum available horizontal length in mm.
#' @param end_depth  `numeric` The desired horizontal length for the ending landing in mm.
#' @param last_step_is_landing `logical` - Whether the arrival level is a landing.
#' @param blondel_target `numeric` - Target Blondel value in mm.
#' @param min_going `numeric` - Minimum acceptable tread depth (horizontal depth of one tread) in mm. Default is 150 mm.
#' @param max_going `numeric` - Maximum acceptable tread depth (horizontal depth of one tread) in mm. Default is 350 mm.
#' @examples
#' s <- stair_compute(height = 850, max_run = 1030)
#' @return Object of class "stair_solution".
#'
#' @export
stair_compute <- function(
    height,
    max_run,
    end_depth = NULL,
    last_step_is_landing = FALSE,
    blondel_target = 630,
    min_going = 150,
    max_going = 350
){

  check_numeric(height, "height")
  check_numeric(max_run, "max_run")

  check_numeric(blondel_target, "blondel_target")
  check_numeric(min_going, "min_going")
  check_numeric(max_going, "max_going")

  if(!is.null(end_depth)) {
    check_numeric(end_depth, "end_depth")
  }

  if(!is.null(end_depth) && end_depth < 0)
    stop("end_depth must be non-negative", call. = FALSE)

  if(max_run <= 0)
    stop("max_run must be positive", call. = FALSE)

  if(min_going < 0)
    stop("min_going must be non-negative", call. = FALSE)

  if(max_going <= min_going)
    stop("max_going must be greater than min_going", call. = FALSE)

  if(blondel_target <= 0)
    stop("blondel_target must be positive", call. = FALSE)

  if(length(last_step_is_landing) != 1 ||
     !is.logical(last_step_is_landing))
    stop("last_step_is_landing must be logical", call. = FALSE)


  rise <- stair_rise(
    height = height
  )


  if(!isTRUE(rise$found_solution))
    stop(
      "no valid stair rise solution found",
      call. = FALSE
    )


  if(rise$n_rises < 2)
    stop(
      "stair must contain at least two rises",
      call. = FALSE
    )


  # Blondel theoretical going
  going <- blondel_target - 2 * rise$rise

  if(going <= 0)
    stop(
      "computed going is not positive",
      call. = FALSE
    )


  # Arrival landing
  if(last_step_is_landing) {

    # Default landing depth = one going
    if(is.null(end_depth)) {
      end_depth <- going
    }

    end <- landing(depth = end_depth)

  } else {

    end <- landing(depth = 0)

  }


  # Available horizontal space after landing
  available_run <- max_run - end$depth


  if(available_run <= 0)
    stop(
      "max_run is insufficient for the specified landing",
      call. = FALSE
    )


  # Maximum possible going with available space
  max_available_going <-
    available_run / (rise$n_rises - 1)


  # Priority:
  # 1. Blondel value
  # 2. Available space limitation
  # 3. Maximum acceptable going
  going <- min(
    going,
    max_available_going,
    max_going
  )


  if(going < min_going)
    stop(
      "available run is insufficient",
      call. = FALSE
    )


  run <- stair_horizontal_run(
    n_rises = rise$n_rises,
    going = going,
    end = end
  )


  geometry <- stair_geometry(
    rise = rise,
    run = run,
    last_step_is_landing = last_step_is_landing
  )


  structure(
    list(
      height = height,

      max_run = max_run,

      unused_run = max(
        0,
        max_run - geometry$overall_run
      ),

      end = end,

      rise = rise,

      build = run,

      geometry = geometry,

      constraints = list(
        blondel_target = blondel_target,
        min_going = min_going,
        max_going = max_going
      )
    ),
    class = "stair_solution"
  )
}


print.stair_solution <- function(x, ...) {

  cat("Stair solution\n\n")

  cat("Height :", x$height, "mm\n")

  cat("Available run :", x$max_run, "mm\n")

  if(x$unused_run > 0)
    cat(
      "Unused run :",
      round(x$unused_run,1),
      "mm\n\n"
    )

  print(x$build)

  cat("\nGeometry steps\n\n")

  print(x$geometry$steps)

  invisible(x)
}
 