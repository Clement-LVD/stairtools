#' Calcule toutes les solutions d'escalier possibles, sans en choisir une
#'
#' Fonction principale du package. Pour chaque nombre de marches valide
#' (\code{\link{optimal_nsteps}}), génère les 5 scénarios de giron
#' (\code{\link{generer_scenarios_giron}}) et leur géométrie complète
#' (\code{\link{construire_geometrie}}), rassemblés dans \strong{une seule
#' table} (\code{\link{construire_table_solutions}}) : géométrie comprise, en
#' colonne-liste. Ne sélectionne aucune "meilleure" solution elle-même — voir
#' \code{\link{meilleure_solution}} pour ça.
#'
#' @param hauteur_a_franchir Hauteur totale à franchir (cm).
#' @param distance_max Distance horizontale disponible (cm).
#' @param h_min Hauteur de marche minimale acceptable (cm). Défaut 16.
#' @param h_max Hauteur de marche maximale acceptable (cm). Défaut 20.
#' @param h_ideale Hauteur de marche idéale (cm). Défaut 16.
#' @param blondel_cible Cible de la formule de Blondel \code{2h + g} (cm). Défaut 63.
#'
#' @return Une liste :
#'   \itemize{
#'     \item \code{candidats_nombre_marches} : data.frame des nombres de
#'       marches valides (issu de \code{\link{optimal_nsteps}})
#'     \item \code{solutions} : LA table (une ligne par nombre de marches ×
#'       scénario), avec \code{ecart_hauteur_ideale}, \code{ecart_blondel},
#'       \code{distance_utilisee}, \code{depasse_espace},
#'       \code{palier_impossible}, et la géométrie complète embarquée dans
#'       \code{geometrie} (colonne-liste : \code{solutions$geometrie[[i]]}
#'       est directement utilisable avec \code{plot()}).
#'   }
#'
#' @examples
#' sol <- calculer_toutes_solutions(hauteur_a_franchir = 160, distance_max = 150)
#' sol$candidats_nombre_marches
#' sol$solutions  # affichage propre (colonne géométrie masquée, cf print.escalier_solutions)
#'
#' # Meilleure solution faisable, géométrie directement accessible :
#' meilleure <- meilleure_solution(sol$solutions)
#' plot(meilleure$geometrie[[1]])
#'
#' # Filtrer/trier à la main, comme un data.frame classique :
#' subset(sol$solutions, n_marches == 10 & !depasse_espace)
#'
#' @export
calculer_toutes_solutions <- function(hauteur_a_franchir,
                                       distance_max,
                                       h_min = 16,
                                       h_max = 20,
                                       h_ideale = 16,
                                       blondel_cible = 63) {

  candidats <- optimal_nsteps(hauteur_a_franchir, h_min, h_max, h_ideale)
  solutions <- construire_table_solutions(candidats, distance_max, blondel_cible)

  if(nrow(solutions) == 0 | all(!solutions$solution_possible)) warning("There is no possibility of a comfortable staircase solution")

  # in order to sort the table : all possible solution first, then sorted by blondel law and - for equally case - sorted as a diff to a theoritical value 
  solutions <- solutions[order(solutions$solution_possible, solutions$ecart_blondel , solutions$ecart_hauteur_ideale , decreasing = c(TRUE, FALSE, FALSE)), ]

  # rank is raw number
  solutions$rank <- seq_len(nrow(solutions))

  list(
    candidats_nombre_marches = candidats,
    solutions = solutions
  )
}
