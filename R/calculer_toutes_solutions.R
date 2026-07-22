#' Calcule toutes les solutions d'escalier possibles, sans en choisir une
#'
#' Fonction principale du package. Pour chaque nombre de marches valide
#' (\code{\link{nombre_marches_optimal}}), génère les 5 scénarios de giron
#' (\code{\link{generer_scenarios_giron}}) et leur géométrie complète
#' (\code{\link{construire_geometrie}}). Ne sélectionne aucune "meilleure"
#' solution : tout est renvoyé pour comparaison ultérieure (voir
#' \code{resume}, qui inclut \code{ecart_hauteur_ideale} et
#' \code{ecart_blondel} pour classer après coup).
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
#'       marches valides (issu de \code{\link{nombre_marches_optimal}})
#'     \item \code{par_candidat} : liste nommée (une entrée par nombre de
#'       marches), chacune avec \code{n_marches}, \code{hauteur_marche},
#'       \code{ecart_hauteur_ideale}, \code{giron_standard}, \code{scenarios}
#'       (5 scénarios de giron) et \code{geometries} (géométrie complète par
#'       scénario, utilisable avec \code{\link{plot_escalier}})
#'     \item \code{resume} : data.frame long, une ligne par combinaison
#'       (nombre de marches × scénario), avec \code{ecart_hauteur_ideale},
#'       \code{ecart_blondel}, \code{distance_utilisee},
#'       \code{depasse_espace}, \code{palier_impossible} — pour comparer et
#'       choisir après coup.
#'   }
#'
#' @examples
#' sol <- calculer_toutes_solutions(hauteur_a_franchir = 200, distance_max = 1000)
#' sol$candidats_nombre_marches
#' head(sol$resume)
#'
#' # Tracer une solution précise :
#' plot(sol$par_candidat$n10$geometries$sans_palier_blondel )
#'
#' # Comparer tous les scénarios du meilleur candidat hauteur (première ligne
#' # de candidats_nombre_marches) par écart à Blondel :
#' meilleur_n <- sol$candidats_nombre_marches$n_marches[1]
#' subset(sol$resume, n_marches == meilleur_n)
#' 
#' sol <- calculer_toutes_solutions(hauteur_a_franchir = 200, distance_max = 160)
#' valid_solution <- sol$resume[!sol$resume$depasse_espace & !sol$resume$palier_impossible ,  ]
#' best_solution <- valid_solution[which.min(valid_solution$ecart_blondel ), ] 
#' best_solution
#' n_marches_best_solution <- paste0("n", best_solution$n_marches)
#' plot(sol$par_candidat[n_marches_best_solution][n_marches_best_solution][best_solution$scenario]geometries$sans_palier_blondel )
#' @export
calculer_toutes_solutions <- function(hauteur_a_franchir,
                                       distance_max,
                                       h_min = 16,
                                       h_max = 20,
                                       h_ideale = 16,
                                       blondel_cible = 63) {

  candidats <- nombre_marches_optimal(hauteur_a_franchir, h_min, h_max, h_ideale)

  par_candidat <- lapply(seq_len(nrow(candidats)), function(i) {

    n_marches <- candidats$n_marches[i]
    hauteur_marche <- candidats$hauteur_marche[i]
    giron_standard <- giron_blondel(hauteur_marche, blondel_cible)

    scenarios <- generer_scenarios_giron(n_marches, distance_max, giron_standard)

    geometries <- lapply(scenarios, function(sc) {
      construire_geometrie(n_marches, hauteur_marche, sc$girons, sc$type_girons)
    })

    list(
      n_marches = n_marches,
      hauteur_marche = hauteur_marche,
      ecart_hauteur_ideale = candidats$ecart_hauteur_ideale[i],
      giron_standard = giron_standard,
      scenarios = scenarios,
      geometries = geometries
    )
  })
  names(par_candidat) <- paste0("n", candidats$n_marches)

  list(
    candidats_nombre_marches = candidats,
    par_candidat = par_candidat,
    resume = resumer_solutions(par_candidat)
  )
}
