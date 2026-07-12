#' Build stair construction elements
#'
#' Converts stair calculations into a sequence of horizontal and vertical
#' elements.
#'
#' @param rise stair_rise object.
#' @param run stair_run object.
#'
#' @return A list of stair elements.
#'
#' @export
stair_elements <- function(
    rise,
    run
) {
  
  
  elements <- list()
  
  
  # Starting landing
  if(run$start$depth > 0) {
    
    elements[[length(elements)+1]] <-
      list(
        type="landing",
        length=run$start$depth,
        height=0
      )
  }
  
  
  # Main stair flight
  for(i in seq_len(run$n_treads)) {
    
    
    elements[[length(elements)+1]] <-
      list(
        type="tread",
        length=run$going,
        height=0
      )
    
    
    elements[[length(elements)+1]] <-
      list(
        type="riser",
        length=0,
        height=rise$rise
      )
  }
  
  
  # Final landing
  if(run$end$depth > 0) {
    
    elements[[length(elements)+1]] <-
      list(
        type="landing",
        length=run$end$depth,
        height=0
      )
  }
  
  
  elements
}