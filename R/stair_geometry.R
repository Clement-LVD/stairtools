#' Create stair geometric model
#'
#' Converts stair rise and run calculations into a construction geometry.
#'
#' @param rise Object of class "stair_rise".
#' @param run Object of class "stair_run".
#'
#' @return Object of class "stair_geometry".
#'
#' @export
stair_geometry <- function(rise, run) {
  
  x <- 0
  y <- 0
  
  profile <- data.frame(
    x = x,
    y = y
  )
  
  steps <- data.frame(
    step = 0,
    x = x,
    height = y
  )
  
  
  # Four walking surfaces
  for(i in seq_len(run$n_treads)) {
    
    # tread
    x <- x + run$going
    
    profile <- rbind(
      profile,
      data.frame(x=x, y=y)
    )
    
    
    # riser
    y <- y + rise$rise
    
    profile <- rbind(
      profile,
      data.frame(x=x, y=y)
    )
    
    
    steps <- rbind(
      steps,
      data.frame(
        step=i,
        x=x,
        height=y
      )
    )
  }
  
  
  # Final rise to upper floor
  if(y < rise$height) {
    
    y <- y + rise$rise
    
    profile <- rbind(
      profile,
      data.frame(
        x=x,
        y=y
      )
    )
    
    
    steps <- rbind(
      steps,
      data.frame(
        step=run$n_rises,
        x=x,
        height=y
      )
    )
  }
  
  
  structure(
    list(
      profile = profile,
      steps = steps,
      height = rise$height,
      n_rises = rise$n_rises,
      rise = rise$rise,
      going = run$going,
      flight_run = run$flight_run,
      units = "mm"
    ),
    class="stair_geometry"
  )
}


#' Plot stair geometry with cumulative dimensions
#'
#' Draws a stair profile and displays cumulative horizontal and vertical
#' dimensions from the starting reference point.
#'
#' @param x Object of class \code{"stair_geometry"}.
#' @param show_dimensions Logical. Display cumulative dimensions.
#'   Default is TRUE.
#' @param ...
#'
#' @return No return value. Produces a base R plot.
#'
#' @export
plot.stair_geometry <- function(
    x,
    show_dimensions = TRUE,
    ...
) {
  
  
  profile <- x$profile
  steps <- x$steps
  
  
  x_max <- max(profile$x)
  y_max <- max(profile$y)
  
  
  # Add space for dimensions
  plot(
    profile$x,
    profile$y,
    type = "n",
    asp = 1,
    xlim = c(-250, x_max + 350),
    ylim = c(-250, y_max + 150),
    xlab = "Horizontal distance (mm)",
    ylab = "Elevation (mm)",
    ...
  )
  
  
  grid()
  
  
  # Stair profile
  lines(
    profile$x,
    profile$y,
    type = "s",
    lwd = 2
  )
  
  
  points(
    profile$x,
    profile$y,
    pch = 16
  )
  
  
  if(show_dimensions) {
    
    
    ## Vertical cumulative dimensions
    
    dim_x <- x_max + 150
    
    
    segments(
      dim_x,
      0,
      dim_x,
      y_max
    )
    
    
    for(i in seq_len(nrow(steps))) {
      
      
      segments(
        dim_x - 20,
        steps$height[i],
        dim_x + 20,
        steps$height[i]
      )
      
      
      text(
        dim_x + 40,
        steps$height[i],
        paste0(
          round(steps$height[i],1),
          " mm"
        ),
        adj = 0
      )
      
    }
    
    
    ## Horizontal cumulative dimensions
    
    dim_y <- -120
    
    
    segments(
      0,
      dim_y,
      x_max,
      dim_y
    )
    
    
    for(i in seq_len(nrow(steps))) {
      
      
      segments(
        steps$x[i],
        dim_y - 20,
        steps$x[i],
        dim_y + 20
      )
      
      
      text(
        steps$x[i],
        dim_y - 50,
        paste0(
          round(steps$x[i],1),
          " mm"
        ),
        cex = 0.8
      )
      
    }
    
    
  }
  
  
  title(
    main = paste0(
      "Stair geometry - ",
      x$height,
      " mm height"
    )
  )
  
}

print.stair_geometry <- function(x, ...) {
  
  cat("Stair geometry\n\n")
  
  cat(
    "Height :",
    x$height,
    "mm\n"
  )
  
  cat(
    "Number of rises :",
    x$n_rises,
    "\n"
  )
  
  cat(
    "Rise :",
    x$rise,
    "mm\n\n"
  )
  
  
  print(x$steps)
  
}