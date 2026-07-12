#' Create stair geometric model
#'
#' Creates the construction geometry of the stair flight.
#'
#' @param rise Object of class "stair_rise".
#' @param run Object of class "stair_run".
#' @param first_step_is_floor Logical.
#' @param last_step_is_landing Logical.
#'
#' @return Object of class "stair_geometry".
#'
#' @export
stair_geometry <- function(
    rise,
    run,
    first_step_is_floor = FALSE,
    last_step_is_landing = FALSE
) {
  
  
  if(!inherits(rise,"stair_rise"))
    stop("rise must be a stair_rise object")
  
  if(!inherits(run,"stair_run"))
    stop("run must be a stair_run object")
  
  
  x <- 0
  y <- 0
  
  
  profile <- data.frame(
    x = x,
    y = y
  )
  
  
  steps <- data.frame(
    level = 0,
    x = x,
    height = y,
    depth = 0,
    type = ifelse(
      first_step_is_floor,
      "floor_step",
      "floor"
    )
  )
  
  
  # Construction of the flight
  
  for(i in seq_len(run$n_treads)) {
    
    
    # horizontal tread
    x <- x + run$going
    
    
    profile <- rbind(
      profile,
      data.frame(
        x=x,
        y=y
      )
    )
    
    
    # riser
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
        level = i,
        x = x,
        height = y,
        depth = run$going,
        type = "tread"
      )
    )
    
  }
  
  
  # Arrival level
  if(y < rise$height) {
    
    
    y <- rise$height
    
    
    profile <- rbind(
      profile,
      data.frame(
        x=x,
        y=y
      )
    )
    
    
    if(last_step_is_landing && run$end$depth > 0) {
      
      steps <- rbind(
        steps,
        data.frame(
          level = rise$n_rises,
          x = x,
          height = y,
          depth = ifelse(
            last_step_is_landing,
            run$going,
            0
          ),
          type = ifelse(
            last_step_is_landing,
            "landing",
            "arrival"
          )
        )
      )
      
    } else {
      
      
      steps <- rbind(
        steps,
        data.frame(
          level=rise$n_rises,
          x=x,
          height=y,
          depth=0,
          type="arrival"
        )
      )
    }
    
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
      
      overall_run = run$overall_run,
      
      
      blondel = 2 * rise$rise + run$going
      
      
     , first_step_is_floor =
        first_step_is_floor,
      
      
      last_step_is_landing =
        last_step_is_landing,
      
      
      start = run$start,
      
      end = run$end,
      
      
      units="mm"
      
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
    "mm\n"
  )
  
  
  cat(
    "Going :",
    x$going,
    "mm\n"
  )
  
  
  cat(
    "Blondel :",
    round(x$blondel,1),
    "mm\n\n"
  )
  
  
  print(x$steps)
  
}