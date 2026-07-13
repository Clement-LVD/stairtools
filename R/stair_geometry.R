#' Create stair geometric model
#'
#' Creates the walkable geometry of a stair flight.
#'
#' @param rise Object of class "stair_rise".
#' @param run Object of class "stair_run".
#' @param last_step_is_landing `logical` - Whether the arrival level is
#' represented as a landing.
#'
#' @return Object of class "stair_geometry".
#'
#' @export
stair_geometry <- function(
    rise,
    run,
    last_step_is_landing = FALSE
) {

  if(length(last_step_is_landing) != 1 ||
     !is.logical(last_step_is_landing)) {
    stop(
      "last_step_is_landing must be logical",
      call. = FALSE
    )
  }

  if(!inherits(rise, "stair_rise"))
    stop(
      "rise must be a stair_rise object",
      call. = FALSE
    )

  if(!isTRUE(rise$found_solution))
    stop(
      "rise object does not contain a valid solution",
      call. = FALSE
    )

  if(!inherits(run, "stair_run"))
    stop(
      "run must be a stair_run object",
      call. = FALSE
    )

  if(run$n_treads < 1)
    stop(
      "run must contain at least one tread",
      call. = FALSE
    )

  if(rise$n_rises != run$n_rises)
    stop(
      "rise and run objects must describe the same number of rises",
      call. = FALSE
    )


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
    type = "floor"
  )


  for(i in seq_len(run$n_treads)) {

    y <- y + rise$rise

    profile <- rbind(
      profile,
      data.frame(
        x = x,
        y = y
      )
    )

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


  # Add arrival landing only when requested
  if(last_step_is_landing && run$end$depth > 0) {

    x <- x + run$end$depth

    profile <- rbind(
      profile,
      data.frame(
        x = x,
        y = rise$height
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

      profile = profile 

      , steps = steps 

      , height = rise$height 

      , n_rises = rise$n_rises 

      , rise = rise$rise 

      , going = run$going 

      , flight_run = run$flight_run 

      , overall_run = x

      , blondel = 2 * rise$rise + run$going 

      , end = run$end 

      , units = "mm"

    ),
    class = "stair_geometry"
  )
}

 #' Plot stair geometry with construction references
#'
#' Draws the stair profile with cumulative dimensions and reference
#' levels showing floor and arrival levels.
#'
#' @param x Object of class "stair_geometry".
#' @param show_dimensions `logical` - Display cumulative dimensions.
#' @param show_references `logical` - Display reference levels.
#' @param ... Additional graphical parameters passed to [plot()].
#'
#' @return No return value. Produces a base R plot.
#'
#' @importFrom graphics abline grid lines points segments text title
#'
#' @export
#' @method plot stair_geometry 
plot.stair_geometry <- function(
    x,
    show_dimensions = TRUE,
    show_references = TRUE,
    ...
) {

  profile <- x$profile

  if (!nrow(profile))
    stop("cannot plot an empty stair geometry")

  steps <- x$steps

  x_max <- max(profile$x)
  y_max <- max(profile$y)

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

  if(show_references) {

    abline(h = 0, lty = 2)

    text(
      x = -250,
      y = 0,
      labels = "Departure",
      adj = 0
    )

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
          round(steps$height[i], 1),
          " mm"
        ),
        adj = 0
      )
    }


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
          round(steps$x[i], 1),
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

  invisible(x)
}