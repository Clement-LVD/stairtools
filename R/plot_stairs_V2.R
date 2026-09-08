compute_geom_fine <- function(geometry,
                              nosing = 0,
                              tread_thickness = 0) {

  # ------------------------------------------------------------------
  # 1. Coordonnées de base
  # ------------------------------------------------------------------
  # x_riser : bord avant théorique de la marche
  # y_top   : dessus de la marche
  #
  # On conserve ces coordonnées intactes et on crée des coordonnées
  # spécifiques à la géométrie "fine".
  # ------------------------------------------------------------------

  geometry$riser_x <- geometry$x_riser
  geometry$riser_top_y <- geometry$y_top


  # ------------------------------------------------------------------
  # 2. Cas où une marche existe
  # ------------------------------------------------------------------
  i <- geometry$has_tread

  # La contremarche est décalée vers l'arrière par le nez de marche.
  #
  # Exemple :
  #   x_riser = 100
  #   nosing  = 2
  #
  # => bord avant de la marche : x = 100
  # => face de la contremarche : x = 102
  #
  geometry$riser_x[i] <-
    geometry$x_riser[i] + nosing


  # ------------------------------------------------------------------
  # 3. Dessous de la marche
  # ------------------------------------------------------------------
  # Le dessous est situé tread_thickness sous le dessus.
  #
  # C'est cette coordonnée qui doit servir de point de raccord
  # entre la marche et la contremarche.
  # ------------------------------------------------------------------

  geometry$riser_top_y[i] <-
    geometry$y_top[i] - tread_thickness


  geometry
}
#' @examples
#' sol <- solve_stairs(total_height = 160, max_horizontal_run = 150)
#' 
#' sol
#' 
#' plot(sol$geometry[[1]])
#' plot_stair(sol$geometry[[1]],  nosing = 2,  tread_thickness = 4)
#' 
plot_stair <- function(geometry,
                       nosing = 0,
                       tread_thickness = 0,
                       riser = TRUE,
                       col = "white",
                       border = "black",
                       ...) {

  # ------------------------------------------------------------------
  # 1. Calcul de la géométrie fine
  # ------------------------------------------------------------------

  g <- compute_geom_fine(
    geometry = geometry,
    nosing = nosing,
    tread_thickness = tread_thickness
  )


  # ------------------------------------------------------------------
  # 2. Initialisation du graphique
  # ------------------------------------------------------------------

  plot(
    NA,
    xlim = range(
      c(g$x_riser, g$x_going_end),
      na.rm = TRUE
    ),
    ylim = range(
      c(g$y_bottom, g$y_top),
      na.rm = TRUE
    ),
    asp = 1,
    axes = FALSE,
    xlab = "",
    ylab = "",
    ...
  )


  # ------------------------------------------------------------------
  # 3. Dessin des marches
  # ------------------------------------------------------------------
  #
  # Chaque marche est un rectangle :
  #
  #       y_top
  #    ┌───────────────
  #    │
  #    │ tread_thickness
  #    │
  #    └───────────────
  #       y_top - thickness
  #
  # Le bord avant reste x_riser.
  # La contremarche, elle, est située à x_riser + nosing.
  #
  # Ainsi le nez de marche est réellement matérialisé.
  # ------------------------------------------------------------------

  for (i in which(g$has_tread)) {

    polygon(
      x = c(
        g$x_riser[i],
        g$x_going_end[i],
        g$x_going_end[i],
        g$x_riser[i]
      ),
      y = c(
        g$y_top[i],
        g$y_top[i],
        g$riser_top_y[i],
        g$riser_top_y[i]
      ),
      col = col,
      border = border
    )
  }


  # ------------------------------------------------------------------
  # 4. Dessin des contremarches
  # ------------------------------------------------------------------
  #
  # IMPORTANT :
  #
  # La contremarche s'arrête maintenant à
  #
  #     riser_top_y
  #
  # et non à y_top.
  #
  # C'est précisément le dessous de la marche.
  #
  # Les deux géométries ont donc exactement le même point :
  #
  #     (riser_x, riser_top_y)
  #
  # Il n'y a plus de décalage vertical.
  # ------------------------------------------------------------------

  if (riser) {

    # Contremarches associées aux marches
    for (i in which(g$has_tread)) {

      segments(
        x0 = g$riser_x[i],
        y0 = g$y_bottom[i],
        x1 = g$riser_x[i],
        y1 = g$riser_top_y[i]
      )
    }


    # Contremarches sans marche
    i <- which(!g$has_tread)

    if (length(i) > 0) {

      segments(
        x0 = g$x_riser[i],
        y0 = g$y_bottom[i],
        x1 = g$x_riser[i],
        y1 = g$y_top[i]
      )
    }
  }


  # ------------------------------------------------------------------
  # 5. Retourner la géométrie calculée
  # ------------------------------------------------------------------

  invisible(g)
}