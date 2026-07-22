#' Sélectionne la meilleure solution dans une table de solutions
#'
#' Filtre les solutions faisables (ni \code{depasse_espace}, ni
#' \code{palier_impossible}) puis retient celle dont \code{ecart_blondel} est
#' le plus faible (les ex-aequo étant départagés par \code{ecart_hauteur_ideale}).
#' La géométrie correspondante est directement accessible sur la ligne
#' retournée, via \code{$geometrie[[1]]} — plus besoin de reconstruire de clés
#' ni de fouiller de listes imbriquées.
#'
#' @param solutions Table issue de \code{\link{construire_table_solutions}}
#'   (ou \code{calculer_toutes_solutions(...)$solutions}).
#'
#' @return Une ligne (data.frame à 1 ligne, classe \code{escalier_solutions})
#'   de \code{solutions}.
#'
#' @examples
#' sol <- calculer_toutes_solutions(hauteur_a_franchir = 200, distance_max = 160)
#' meilleure <- meilleure_solution(sol$solutions)
#' meilleure[, c("n_marches", "scenario", "ecart_blondel")]
#' plot(meilleure$geometrie[[1]])
#'
#' @export
meilleure_solution <- function(solutions) {

  faisables <- solutions[solutions$solution_possible, ]

  if (nrow(faisables) == 0) {
    stop("Aucune solution faisable (toutes dépassent l'espace disponible ou sont impossibles). ",
         "==> Essayez d'élargir h_min/h_max, d'augmenter distance_max, voire de diminuer ou augmenter la valeur blondel_cible.")
  }

  #we have a scoring var' to this point
  ordre <- order(faisables$rank)
  
  best_solution <- faisables[ordre[1], ]

  if(best_solution$blondel_value < 60 | best_solution$blondel_value > 64) 
    warning(call. = FALSE, "The better solution does not result in a comfortable staircase, i.e. the value obtained from Blondel's formula is greater than 64 cm or smaller than 60 cm.
    ==> Vous devez augmenter la distance_max")

  return(best_solution)
}
