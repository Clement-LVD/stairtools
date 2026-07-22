#' Trace le profil d'un escalier (base R)
#'
#' Trace chaque contremarche (segment vertical) et chaque giron (segment
#' horizontal) à partir d'un data.frame de géométrie produit par
#' \code{\link{construire_geometrie}} (ou d'une ligne de
#' \code{calculer_toutes_solutions(...)$solutions$geometrie[[i]]}).
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
#' @param cotes Logique. Si \code{TRUE}, ajoute les côtes cumulées (x en bas,
#'   y à gauche) sur chaque marche — voir \code{\link{plot_escalier_cotes}}
#'   pour un raccourci. Défaut \code{FALSE}.
#' @param cex_cotes Taille du texte des côtes (si \code{cotes = TRUE}). Défaut 0.6.
#' @param ... Arguments supplémentaires passés à \code{plot()}.
#'
#' @examples
#' geo <- construire_geometrie(5, 17.33, rep(28.33, 4))
#' plot_escalier(geo)
#' plot(geo)  # identique, grâce à la classe escalier_geometrie
#' plot_escalier(geo, cotes = TRUE)  # avec les côtes cumulées
#'
#' # Sur une solution issue de calculer_toutes_solutions() :
#' sol <- calculer_toutes_solutions(hauteur_a_franchir = 160, distance_max = 1000)
#' meilleure <- meilleure_solution(sol$solutions)
#' plot(meilleure$geometrie[[1]])
#'
#' @export
plot_escalier <- function(geometrie, col_standard = "black", col_paliere = "red",
                           col_sol = "gray50", cotes = FALSE, cex_cotes = 0.6, ...) {

  x_max <- max(geometrie$x_fin_giron, geometrie$x_contremarche, na.rm = TRUE)
  y_max <- max(geometrie$y_haut, na.rm = TRUE)
  y_min <- min(geometrie$y_bas, na.rm = TRUE)

  # Marge additionnelle pour loger les côtes, si demandées
  marge_x <- if (cotes) 0.10 * (x_max - 0) else 0
  marge_y <- if (cotes) 0.10 * (y_max - y_min) else 0

  plot(NA, xlim = c(0 - marge_x, x_max), ylim = c(y_min - marge_y, y_max), asp = 1,
       xlab = "Distance (cm)", ylab = "Hauteur (cm)", ...)

  # Sols finis de départ (y_min, typiquement 0) et d'arrivée (y_max), en pointillés
  graphics::abline(h = y_min, lty = 2, col = col_sol)
  graphics::abline(h = y_max, lty = 2, col = col_sol)
  graphics::text(x_max, y_min, "sol fini (départ)", pos = 3, cex = 0.7, col = col_sol)
  graphics::text(0, y_max, "sol fini (arrivée)", pos = 3, cex = 0.7, col = col_sol)

  for (i in seq_len(nrow(geometrie))) {

    # Contremarche (segment vertical)
    graphics::segments(
      geometrie$x_contremarche[i], geometrie$y_bas[i],
      geometrie$x_contremarche[i], geometrie$y_haut[i],
      lwd = 2
    )

    # Giron (segment horizontal), absent pour la dernière ligne (arrivée palier)
    if (!is.na(geometrie$giron[i])) {
      couleur <- if (identical(geometrie$type_giron[i], "paliere")) col_paliere else col_standard
      graphics::segments(
        geometrie$x_contremarche[i], geometrie$y_haut[i],
        geometrie$x_fin_giron[i], geometrie$y_haut[i],
        lwd = 2, col = couleur
      )
    }
  }

  if (cotes) {

    # Côte horizontale cumulée : x_fin_giron de chaque marche, sous l'escalier
    y_ligne_cote_x <- y_min - marge_y * 0.4
    y_texte_cote_x <- y_min - marge_y * 0.9
    for (i in seq_len(nrow(geometrie))) {
      if (!is.na(geometrie$x_fin_giron[i])) {
        graphics::segments(geometrie$x_fin_giron[i], y_min, geometrie$x_fin_giron[i], y_ligne_cote_x,
                  lty = 3, col = "gray60")
        graphics::text(geometrie$x_fin_giron[i], y_texte_cote_x, round(geometrie$x_fin_giron[i], 1),
             srt = 90, cex = cex_cotes, adj = 1, col = "gray30", xpd = TRUE)
      }
    }

    # Côte verticale cumulée : y_haut de chaque contremarche, à gauche de l'escalier
    x_ligne_cote_y <- 0 - marge_x * 0.4
    x_texte_cote_y <- 0 - marge_x * 0.9
    for (i in seq_len(nrow(geometrie))) {
      graphics::segments(0, geometrie$y_haut[i], x_ligne_cote_y, geometrie$y_haut[i],
                lty = 3, col = "gray60")
      graphics::text(x_texte_cote_y, geometrie$y_haut[i], round(geometrie$y_haut[i], 1),
           cex = cex_cotes, adj = 1, col = "gray30", xpd = TRUE)
    }
  }
}

#' Trace le profil d'un escalier avec les côtes cumulées (vue détaillée)
#'
#' Raccourci pour \code{plot_escalier(geometrie, cotes = TRUE, ...)}. Affiche,
#' en plus du profil : la position x cumulée de fin de chaque giron (sous
#' l'escalier) et la hauteur y cumulée de chaque contremarche (à gauche) — de
#' quoi coter le dessin marche par marche sans avoir à relire les colonnes du
#' data.frame.
#'
#' @param geometrie Un data.frame de géométrie (voir \code{\link{construire_geometrie}}).
#' @param ... Arguments supplémentaires passés à \code{\link{plot_escalier}}.
#'
#' @examples
#' sol <- calculer_toutes_solutions(hauteur_a_franchir = 160, distance_max = 1000)
#' meilleure <- meilleure_solution(sol$solutions)
#' plot_escalier_cotes(meilleure$geometrie[[1]])
#'
#' @export
plot_escalier_cotes <- function(geometrie, ...) {
  plot_escalier(geometrie, cotes = TRUE, ...)
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
#' plot(geo, cotes = TRUE)
#'
#' @export
plot.escalier_geometrie <- function(x, ...) {
  plot_escalier(x, ...)
}
