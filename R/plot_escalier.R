#' Trace le profil d'un escalier (base R)
#'
#' Trace chaque contremarche (segment vertical) et chaque giron (segment
#' horizontal) à partir d'un data.frame de géométrie produit par
#' \code{\link{construire_geometrie}} (ou \code{calculer_toutes_solutions(...)$par_candidat[[...]]$geometries[[...]]}).
#' La marche palière (le cas échéant) est mise en évidence dans une couleur
#' différente. Le sol fini de départ (y=0) et d'arrivée (y=hauteur max) sont
#' tracés en pointillés pour repère.
#'
#' Les géométries produites par \code{\link{construire_geometrie}} portent la
#' classe \code{escalier_geometrie} : appeler \code{plot()} directement dessus
#' fonctionne aussi (voir \code{\link{plot.escalier_geometrie}}), pas besoin
#' d'appeler \code{plot_escalier()} par son nom.
#'
#' @param geometrie Un data.frame de géométrie (voir \code{\link{construire_geometrie}}).
#' @param col_standard Couleur des girons standards. Défaut "black".
#' @param col_paliere Couleur du giron de la marche palière. Défaut "red".
#' @param col_sol Couleur des lignes pointillées de sol fini. Défaut "gray50".
#' @param ... Arguments supplémentaires passés à \code{plot()}.
#'
#' @examples
#' geo <- construire_geometrie(5, 17.33, rep(28.33, 4))
#' plot_escalier(geo)
#' plot(geo)  # identique, grâce à la classe escalier_geometrie
#'
#' # Sur une solution issue de calculer_toutes_solutions() :
#' sol <- calculer_toutes_solutions(hauteur_a_franchir = 160, distance_max = 1000)
#' plot_escalier(sol$par_candidat$n10$geometries$avec_palier_max)
#'
#' @export
plot_escalier <- function(geometrie, col_standard = "black", col_paliere = "red",
                           col_sol = "gray50", ...) {

  x_max <- max(geometrie$x_fin_giron, geometrie$x_contremarche, na.rm = TRUE)
  y_max <- max(geometrie$y_haut, na.rm = TRUE)
  y_min <- min(geometrie$y_bas, na.rm = TRUE)

  plot(NA, xlim = c(0, x_max), ylim = c(y_min, y_max), asp = 1,
       xlab = "Distance (cm)", ylab = "Hauteur (cm)", ...)

  # Sols finis de départ (y_min, typiquement 0) et d'arrivée (y_max), en pointillés
  abline(h = y_min, lty = 2, col = col_sol)
  abline(h = y_max, lty = 2, col = col_sol)
  text(x_max, y_min, "sol fini (départ)", pos = 3, cex = 0.7, col = col_sol)
  text(0, y_max, "sol fini (arrivée)", pos = 3, cex = 0.7, col = col_sol)

  for (i in seq_len(nrow(geometrie))) {

    # Contremarche (segment vertical)
    segments(
      geometrie$x_contremarche[i], geometrie$y_bas[i],
      geometrie$x_contremarche[i], geometrie$y_haut[i],
      lwd = 2
    )

    # Giron (segment horizontal), absent pour la dernière ligne (arrivée palier)
    if (!is.na(geometrie$giron[i])) {
      couleur <- if (identical(geometrie$type_giron[i], "paliere")) col_paliere else col_standard
      segments(
        geometrie$x_contremarche[i], geometrie$y_haut[i],
        geometrie$x_fin_giron[i], geometrie$y_haut[i],
        lwd = 2, col = couleur
      )
    }
  }
}

#' Méthode plot() pour les géométries d'escalier
#'
#' Permet d'appeler \code{plot(geometrie)} directement sur une géométrie
#' produite par \code{\link{construire_geometrie}} (classe
#' \code{escalier_geometrie}), sans passer par \code{plot.data.frame()} (qui
#' produirait un pairs-plot illisible). Délègue entièrement à
#' \code{\link{plot_escalier}}.
#'
#' @param x Un data.frame de géométrie de classe \code{escalier_geometrie}.
#' @param ... Arguments passés à \code{\link{plot_escalier}}.
#'
#' @examples
#' geo <- construire_geometrie(5, 17.33, rep(28.33, 4))
#' plot(geo)
#'
#' @export
plot.escalier_geometrie <- function(x, ...) {
  plot_escalier(x, ...)
}

