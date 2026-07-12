
#' Internal constructor for failed stair_rise results
#' @noRd
stair_rise_no_solution <- function(
    height,
    target_rise,
    min_rise,
    max_rise
) { 
  structure(
    list(
      height = height,
      n_rises = NA_integer_,
      rise = NA_real_,
      candidates = data.frame(),
      target_rise = target_rise,
      min_rise = min_rise,
      max_rise = max_rise,
      units = "mm",
      found_solution = FALSE
    ),
    class = "stair_rise"
  )
}

#' Calculate stair vertical geometry
#'
#' Determines the number of rises that gives the closest match
#' to the target rise while respecting minimum and maximum limits.
#'
#' @param height `numeric` - Total height in mm.
#' @param target_rise `numeric` - Target rise height in mm.
#' @param min_rise `numeric` - Minimum allowed rise height in mm.
#' @param max_rise `numeric` - Maximum allowed rise height in mm.
#'
#' @return Return an object of class "stair_rise".
#' @examples
#' stair_rise(3000)
#'
#' stair_rise(
#'   height = 1000,
#'   min_rise = 160,
#'   max_rise = 250
#' )
#' @export

stair_rise <- function(
    height
    , target_rise = 160
    , min_rise = 160
    , max_rise = 200
) {
# sanity checks
check_numeric(height, "height")
check_numeric(target_rise, "target_rise")
check_numeric(min_rise, "min_rise")
check_numeric(max_rise, "max_rise")

if (height <= 0) stop("height must be positive: elevation '0' is the bottom-floor reference")

if (min_rise > max_rise) stop("min_rise must be lower than max_rise")

if (target_rise < min_rise || target_rise > max_rise){
warning("target_rise (", target_rise, ") is outside allowed range (", min_rise, "-", max_rise, ")"
      ,  call. = FALSE)}
  
  
  # Candidate numbers of rises
  n_min <- ceiling(height / max_rise)
  n_max <- floor(height / min_rise)
  
  if(n_min > n_max){ return(stair_rise_no_solution(height, target_rise, min_rise, max_rise  ) )   }
  
    candidates <- data.frame(  n_rises = seq(n_min, n_max)  )
  
  # Calculate exact rise height
  candidates$rise <- height / candidates$n_rises
  
  # Remove invalid solutions
  keep <- candidates$rise >= min_rise &
        candidates$rise <= max_rise

candidates <- candidates[keep, , drop = FALSE]
  
  if (!nrow(candidates)) {return(stair_rise_no_solution(height, target_rise, min_rise, max_rise  ) ) }
  
  
  # Optimisation criterion
  candidates$score <- abs( candidates$rise - target_rise )
  
  
  candidates <- candidates[ order(candidates$score), ]
  
  structure(
    list(
      height = height
      , n_rises = candidates$n_rises[1]
      , rise = candidates$rise[1]
      , score = candidates$score[1]
      , candidates = candidates
      , target_rise = target_rise
      , min_rise = min_rise
      , max_rise = max_rise
      , units = "mm"
      , found_solution = TRUE
    ),
    class = "stair_rise"
  )
}

#' @export
#' @method print stair_rise
print.stair_rise <- function(x, ...) {

  cat("Stair rise calculation\n\n")
  
  cat("Height :", x$height, "mm\n")

  if (isFALSE(x$found_solution)) { cat("\nNo valid stair solution found\n")
    return(invisible(x))
  }

  cat( "Number of rises :",  x$n_rises,  "\n"  )

  cat(  "Rise :", round(x$rise, 1),  "mm\n"  )

  invisible(x)
}

#' @export
#' @method summary stair_rise
summary.stair_rise <- function(object, ...) {
  list(
    height = object$height
    , rises = object$n_rises
    , rise = object$rise
    , found_solution = object$found_solution
  )
}