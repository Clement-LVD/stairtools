#' Solve complete stair geometry
#'
#' Calculates optimal and space-fitted stair solutions.
#'
#' @param height Total height to overcome in mm.
#' @param max_run Maximum available horizontal length in mm.
#'
#' @return Object of class "stair_solution".
#'
#' @export
stair_solve <- function(
    height,
    max_run,
    start = landing(),
    end = landing(),
    first_step_is_floor = FALSE,
    last_step_is_landing = FALSE
) {
  
  
  rise <- stair_rise(
    height = height
  )
  
  
  run <- stair_horizontal_run(
    n_rises = rise$n_rises,
    going = max_run / (rise$n_rises - 1),
    start = start,
    end = end
  )
  
  geometry <- stair_geometry(
    rise = rise,
    run = run,
    first_step_is_floor = first_step_is_floor,
    last_step_is_landing = last_step_is_landing
  )
  
  
  structure(
    list(
      height = height,
      max_run = max_run,
      
      start = start,
      end = end,
      
      rise = rise,
      
      build = run,
      
      geometry = geometry,
      
      recommended = "build"
    ),
    class = "stair_solution"
  )
}
print.stair_solution <- function(x, ...) {
  
  cat("Stair solution\n\n")
  
  cat(
    "Height :",
    x$height,
    "mm\n"
  )
  
  cat(
    "Available run :",
    x$max_run,
    "mm\n\n"
  )
  
  
  print(x$rise)
  
  
  cat(
    "\nRecommended solution :",
    x$recommended,
    "\n\n"
  )
  
  
  if(x$recommended == "optimal") {
    
    print(x$optimal)
    
  } else {
    
    print(x$build)
  }
  
  
  cat("\nGeometry\n\n")
  
  print(x$geometry)
}