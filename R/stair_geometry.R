#' Create stair geometric model
#'
#' @param elements Stair element list.
#'
#' @return Object of class "stair_geometry".
#'
#' @export
stair_geometry <- function(
    elements
) {
  
  
  x <- 0
  y <- 0
  
  
  profile <- data.frame(
    x=x,
    y=y
  )
  
  
  for(el in elements) {
    
    
    # Horizontal movement
    x <- x + el$length
    
    
    profile <-
      rbind(
        profile,
        data.frame(
          x=x,
          y=y
        )
      )
    
    
    # Vertical movement
    y <- y + el$height
    
    
    profile <-
      rbind(
        profile,
        data.frame(
          x=x,
          y=y
        )
      )
  }
  
  
  structure(
    list(
      profile = profile,
      elements = elements,
      units="mm"
    ),
    class="stair_geometry"
  )
}