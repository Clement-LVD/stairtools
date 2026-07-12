#' Create stair geometric model
#'
#' Creates the walkable geometry of a stair flight.
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
    x = numeric(),
    y = numeric()
  )
  
  
  steps <- data.frame(
    level = 0,
    x = 0,
    height = 0,
    depth = 0,
    type = ifelse(
      first_step_is_floor,
      "floor_step",
      "floor"
    )
  )
  
  
  #
  # Construction du profil réel
  #
  
  for(i in seq_len(run$n_treads)) {
    
    
    # montée
    y <- y + rise$rise
    
    profile <- rbind(
      profile,
      data.frame(
        x = x,
        y = y
      )
    )
    
    
    # marche
    x <- x + run$going
    
    profile <- rbind(
      profile,
      data.frame(
        x = x,
        y = y
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
  
  
  #
  # Arrivée
  #
  
  # dernière hauteur
  if(y < rise$height) {
    
    y <- rise$height
    
    profile <- rbind(
      profile,
      data.frame(
        x = x,
        y = y
      )
    )
    
  }
  
  
  steps <- rbind(
    steps,
    data.frame(
      level = rise$n_rises,
      x = x,
      height = rise$height,
      depth = ifelse(
        last_step_is_landing,
        run$end$depth,
        0
      ),
      type = ifelse(
        last_step_is_landing,
        "landing",
        "arrival"
      )
    )
  )
  
  
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
      
      blondel = 2 * rise$rise + run$going,
      
      first_step_is_floor = first_step_is_floor,
      
      last_step_is_landing = last_step_is_landing,
      
      start = run$start,
      
      end = run$end,
      
      units = "mm"
      
    ),
    class="stair_geometry"
  )
}

#' Plot stair geometry with construction references
#'
#' Draws the stair profile with cumulative dimensions and reference
#' levels showing floor and arrival levels.
#'
#' @param x Object of class "stair_geometry".
#' @param show_dimensions Logical. Display dimensions.
#' @param show_references Logical. Display reference levels.
#' @param ...
#'
#' @return No return value. Produces a base R plot.
#'
#' @export
plot.stair_geometry <- function(
    x,
    show_dimensions = TRUE,
    show_references = TRUE,
    ...
) {
  
  
  profile <- x$profile
  steps <- x$steps
  
  x_max <- max(profile$x)
  y_max <- max(profile$y)
  
  
  # Margins for dimensions
  plot(
    profile$x,
    profile$y,
    type = "n",
    asp = 1,
    xlim = c(-350, x_max + 450),
    ylim = c(-250, y_max + 250),
    xlab = "Horizontal distance (mm)",
    ylab = "Elevation (mm)",
    ...
  )
  
  
  grid()
  
  
  # Reference levels
  if(show_references) {
    
    
    # Starting floor reference
    abline(
      h = 0,
      lty = 2
    )
    
    
    text(
      x = -250,
      y = 0,
      labels = "Departure",
      adj = 0
    )
    
    
    # Arrival finished level
    abline(
      h = x$height,
      lty = 2
    )
    
    
    text(
      x = -250,
      y = x$height,
      labels = "Arrival",
      adj = 0
    )
    
    
    # Theoretical vertical limits
    segments(
      0,
      0,
      0,
      x$rise,
      lty = 2
    )
    
    
    segments(
      x$flight_run,
      y_max - x$rise,
      x$flight_run,
      y_max,
      lty = 2
    )
    
  }
  
  
  # Real stair profile
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
    
    
    #
    # Vertical cumulative dimensions
    #
    
    dim_x <- x_max + 180
    
    
    segments(
      dim_x,
      0,
      dim_x,
      y_max
    )
    
    
    for(i in seq_len(nrow(steps))) {
      
      segments(
        dim_x - 25,
        steps$height[i],
        dim_x + 25,
        steps$height[i]
      )
      
      text(
        dim_x + 50,
        steps$height[i],
        paste0(
          round(steps$height[i],1),
          " mm"
        ),
        adj = 0
      )
      
    }
    
    
    #
    # Horizontal cumulative dimensions
    #
    
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