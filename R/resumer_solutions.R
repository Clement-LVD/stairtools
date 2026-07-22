#' Résume toutes les solutions en un data.frame comparatif
#'
#' Aplatit la structure \code{par_candidat} de \code{\link{calculer_toutes_solutions}}
#' en un data.frame long, une ligne par combinaison (nombre de marches × scénario),
#' pour permettre de comparer et classer après coup (par \code{ecart_hauteur_ideale},
#' \code{ecart_blondel}, faisabilité, etc.).
#'
#' @param par_candidat Liste issue de \code{calculer_toutes_solutions(...)$par_candidat}.
#'
#' @return Un \code{data.frame} avec les colonnes : \code{n_marches},
#'   \code{hauteur_marche}, \code{ecart_hauteur_ideale}, \code{scenario},
#'   \code{distance_utilisee}, \code{ecart_blondel}, \code{depasse_espace},
#'   \code{palier_impossible}.
#'
#' @examples
#' sol <- calculer_toutes_solutions(hauteur_a_franchir = 160, distance_max = 1000)
#' resumer_solutions(sol$par_candidat)  # identique à sol$resume
#'
#' @export
resumer_solutions <- function(par_candidat) {

  lignes_par_candidat <- lapply(par_candidat, function(cand) {

    lignes <- lapply(names(cand$scenarios), function(nom_scenario) {
      sc <- cand$scenarios[[nom_scenario]]
      data.frame(
        n_marches = cand$n_marches,
        hauteur_marche = cand$hauteur_marche,
        ecart_hauteur_ideale = cand$ecart_hauteur_ideale,
        scenario = nom_scenario,
        distance_utilisee = sc$distance_utilisee,
        ecart_blondel = sc$ecart_blondel,
        depasse_espace = isTRUE(sc$depasse_espace),
        palier_impossible = isTRUE(sc$palier_impossible),
        stringsAsFactors = FALSE
      )
    })
    do.call(rbind, lignes)
  })

  res <- do.call(rbind, lignes_par_candidat)
  rownames(res) <- NULL
  res
}
