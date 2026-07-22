#' Calcule le giron optimal selon la formule de Blondel (cible fixe)
#'
#' Applique la relation \code{2 * hauteur_marche + giron = cible} (cible = 63 cm
#' par défaut, valeur de confort classique) pour en déduire le giron.
#'
#' @param hauteur_marche Hauteur de marche (cm), typiquement issue de
#'   \code{\link{optimal_nsteps}}.
#' @param cible Valeur cible de la relation de Blondel \code{2h + g} (cm). Défaut 63.
#'
#' @return Le giron (profondeur de marche) en cm.
#'
#' @examples
#' giron_blondel(16.25)  # 30.5
#' giron_blondel(20)     # 23
#'
#' @export
giron_blondel <- function(hauteur_marche, cible = 63) {
  giron <- cible - 2 * hauteur_marche
  if (any(giron <= 0)) {
    warning("Giron calculé négatif ou nul : hauteur_marche trop grande pour la cible de Blondel choisie.")
  }
  giron
}
