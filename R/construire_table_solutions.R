#' Construit la table complète de toutes les solutions (géométrie embarquée)
#'
#' Calcule, pour chaque nombre de marches valide et chaque scénario de giron
#' (\code{\link{generer_scenarios_giron}}), une ligne de synthèse avec la
#' géométrie complète (\code{\link{construire_geometrie}}) embarquée en
#' colonne-liste \code{geometrie}. On peut filtrer/trier la table avec les outils
#' habituels de data.frame, puis accéder directement à la géométrie de la
#' ligne retenue via \code{ligne$geometrie[[1]]}.
#'
#' @param candidats data.frame issu de \code{\link{optimal_nsteps}}.
#' @param distance_max Distance horizontale disponible (cm).
#' @param blondel_cible Cible de la formule de Blondel \code{2h + g} (cm). Défaut 63.
#'
#' @return Un \code{data.frame} (classe additionnelle \code{escalier_solutions})
#'   avec une ligne par combinaison (nombre de marches × scénario) :
#'   \code{n_marches}, \code{hauteur_marche}, \code{ecart_hauteur_ideale},
#'   \code{giron_standard}, \code{scenario}, \code{distance_utilisee},
#'   \code{ecart_blondel}, \code{depasse_espace}, \code{palier_impossible},
#'   \code{geometrie} (colonne-liste : un data.frame de géométrie par ligne).
#'
#' @examples
#' candidats <- optimal_nsteps(hauteur_a_franchir = 160)
#' tbl <- construire_table_solutions(candidats, distance_max = 1000)
#' head(tbl[, c("n_marches", "scenario", "ecart_blondel")])
#' plot(tbl$geometrie[[1]])
#'
#' @export
construire_table_solutions <- function(candidats, distance_max, blondel_cible = 63) {

  lignes_par_candidat <- lapply(seq_len(nrow(candidats)), function(i) {

    n_marches <- candidats$n_marches[i]
    hauteur_marche <- candidats$hauteur_marche[i]
    ecart_hauteur_ideale <- candidats$ecart_hauteur_ideale[i]
    giron_standard <- giron_blondel(hauteur_marche, blondel_cible)

    scenarios <- generer_scenarios_giron(n_marches, distance_max, giron_standard)

    lignes <- lapply(names(scenarios), function(nom_scenario) {
      sc <- scenarios[[nom_scenario]]
      geometrie <- construire_geometrie(n_marches, hauteur_marche, sc$girons, sc$type_girons)

      data.frame(
        n_marches            = n_marches,
        hauteur_marche       = hauteur_marche,
        ecart_hauteur_ideale = ecart_hauteur_ideale,
        giron_standard       = giron_standard,
        scenario             = nom_scenario,
        distance_utilisee    = sc$distance_utilisee,
        blondel_value        = (2 * hauteur_marche) + sc$giron[[1]],
        ecart_blondel        = sc$ecart_blondel,
        avec_paliere         = isTRUE(sc$avec_paliere),
        depasse_espace       = isTRUE(sc$depasse_espace),
        palier_impossible    = isTRUE(sc$palier_impossible),
        geometrie            = I(list(geometrie)),
        stringsAsFactors     = FALSE
      )
    })

    do.call(rbind, lignes)
  })

  res <- do.call(rbind, lignes_par_candidat)

  # a possible solution fit in lenght & don't have a paliere step OR there is a POSSIBLE paliere step
  res$solution_possible <- !res$depasse_espace & (res$avec_paliere == FALSE | (res$avec_paliere == TRUE & !res$palier_impossible))

  rownames(res) <- NULL
  class(res) <- c("escalier_solutions", class(res))
  res
}

#' Affiche une table de solutions sans la colonne-liste geometrie
#'
#' La colonne \code{geometrie} contient des data.frames complets : son
#' affichage brut serait illisible. Cette méthode masque cette colonne à
#' l'impression (elle reste accessible normalement via \code{$geometrie}).
#'
#' @param x Table de classe \code{escalier_solutions}.
#' @param ... Arguments passés à \code{print.data.frame}.
#'
#' @export
print.escalier_solutions <- function(x, ...) {
  print.data.frame(x[, setdiff(names(x), "geometrie")], ...)
  cat("(colonne 'geometrie' masquée à l'affichage — accessible via $geometrie[[i]])\n")
  invisible(x)
}
