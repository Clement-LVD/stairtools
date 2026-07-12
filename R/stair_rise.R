#' Calculate stair vertical geometry
#'
#' Finds the best number of rises for a given height.
#'
#' @param height Total height in mm.
#' @param target_rise Target rise height.
#' @param min_rise Minimum allowed rise.
#' @param max_rise Maximum allowed rise.
#'
#' @return Object of class "stair_rise".
#'
#' @export
stair_rise <- function(
    height,
    target_rise = 160,
    min_rise = 160,
    max_rise = 200
) {
  
  
  if (height <= 0)
    stop("height must be positive")
  
  
  # Candidate numbers of rises
  candidates <- data.frame(
    n_rises =
      seq(
        ceiling(height / max_rise),
        floor(height / min_rise)
      )
  )
  
  
  # Calculate exact rise height
  candidates$rise <-
    height / candidates$n_rises
  
  
  # Remove invalid solutions
  candidates <-
    candidates[
      candidates$rise >= min_rise &
        candidates$rise <= max_rise,
    ]
  
  
  if (!nrow(candidates))
    stop("No valid rise solution")
  
  
  # Optimisation criterion
  candidates$score <-
    abs(
      candidates$rise -
        target_rise
    )
  
  
  candidates <-
    candidates[
      order(candidates$score),
    ]
  
  
  structure(
    list(
      height = height,
      n_rises = candidates$n_rises[1],
      rise = candidates$rise[1],
      candidates = candidates,
      units = "mm"
    ),
    class = "stair_rise"
  )
}