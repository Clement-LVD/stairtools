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
#' @param show_invalid_solution `logical` - Show all the solution, even invalid 
#' @return Return a `data.frame` (une ligne par nombre de marches ×
#'       scenario) with :
#'   - ecart_hauteur_ideale
#'   - ecart_blondel 
#'   - distance_utilisee 
#'   - depasse_espace 
#'   - palier_impossible 
#'   - geometrie - complete geometrie as a `list-column` (\code{solutions$geometrie[[i]]}
#'       est directement utilisable avec \code{plot()}).
#' 
#' Additional attributes give some interesting values :
#' 
#'     - `candidats_nombre_marches` : `data.frame` des nombres de
#'       marches valides (issu de \code{\link{optimal_nsteps}}) 
#'     - `n_valid_solution` : `integer` - The number of valid solution(s). Equivalent to nrow() of the returned `data.frame` if the parameter `show_invalid_solution` is FALSE (the default)
#'
#' @examples
#' sol <- calculer_toutes_solutions(hauteur_a_franchir = 160, distance_max = 150)
#' sol  # affichage propre (colonne géométrie masquée, cf print.escalier_solutions)
#'
#' # Or get all the solutions, even impossibles
#' sol2 <- calculer_toutes_solutions(160, 150, show_invalid_solution = TRUE)
#' # Meilleure solution faisable, géométrie directement accessible :
#' meilleure <- meilleure_solution(sol2)
#' plot(meilleure$geometrie[[1]])
#'
#' # Filtrer/trier à la main, comme un data.frame classique :
#' subset(sol, n_marches == 10 & !depasse_espace)
#'
#' @export
calculer_toutes_solutions <- function(hauteur_a_franchir 
                                       , distance_max 
                                       , h_min = 16 
                                       , h_max = 20 
                                       , h_ideale = 16 
                                       , blondel_cible = 63
                                       , show_invalid_solution = FALSE) {

  candidats <- optimal_nsteps(hauteur_a_franchir, h_min, h_max, h_ideale)
  solutions <- construire_table_solutions(candidats, distance_max, blondel_cible)

  if(nrow(solutions) == 0 | all(!solutions$solution_possible)) warning("No possibility of a comfortable staircase solution")


  # in order to sort the table : all possible solution first, then sorted by blondel law and - for equally case - sorted as a diff to a theoritical value 
  solutions <- solutions[order(solutions$solution_possible, solutions$ecart_blondel , solutions$ecart_hauteur_ideale , decreasing = c(TRUE, FALSE, FALSE)), ]

  # rank is raw number
  solutions$rank <- seq_len(nrow(solutions))

  if(!show_invalid_solution){solutions <- solutions[solutions$solution_possible == TRUE, ]}

  attr(solutions, "scenarios_n_steps") <- candidats

return( solutions = solutions ) 

}
