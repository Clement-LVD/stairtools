#' Détermine le(s) nombre(s) de marches possibles pour franchir une hauteur donnée
#'
#' Calcule, pour chaque nombre de contremarches compatible avec les bornes
#' \code{h_min}/\code{h_max}, la hauteur de marche associée et son écart à la
#' hauteur idéale. Retourne toutes les solutions valides, triées par écart
#' croissant (la meilleure solution est donc la première ligne).
#'
#' @param hauteur_a_franchir Hauteur totale à franchir (cm).
#' @param h_min Hauteur de marche minimale acceptable (cm). Défaut 16.
#' @param h_max Hauteur de marche maximale acceptable (cm). Défaut 20.
#' @param h_ideale Hauteur de marche idéale, servant de référence pour le tri (cm). Défaut 16.
#'
#' @return Un \code{data.frame} avec une ligne par nombre de marches valide, colonnes :
#'   \code{n_marches}, \code{hauteur_marche}, \code{ecart_hauteur_ideale}.
#'   Trié par \code{ecart_hauteur_ideale} croissant.
#'
#' @examples
#' nombre_marches_optimal(hauteur_a_franchir = 260)
#' #   n_marches hauteur_marche ecart_hauteur_ideale
#' # 4        16       16.25000             0.250000
#' # ...
#'
#' @export
nombre_marches_optimal <- function(hauteur_a_franchir,
                                    h_min = 16,
                                    h_max = 20,
                                    h_ideale = 16) {

  if (hauteur_a_franchir <= 0) stop("hauteur_a_franchir doit être strictement positive.")
  if (h_min <= 0 || h_max <= 0 || h_min >= h_max) stop("h_min doit être positif et strictement inférieur à h_max.")
  if (h_ideale < h_min || h_ideale > h_max) {
    warning("h_ideale est en dehors de l'intervalle [h_min, h_max].")
  }

  # n marches -> hauteur = hauteur_a_franchir / n
  # on veut h_min <= hauteur <= h_max
  n_min <- ceiling(hauteur_a_franchir / h_max)
  n_max <- floor(hauteur_a_franchir / h_min)

  if (n_min > n_max) {
    stop(sprintf(
      "Aucune solution : impossible de franchir %.1f cm avec des marches entre %.1f et %.1f cm. Élargir h_min/h_max.",
      hauteur_a_franchir, h_min, h_max
    ))
  }

  n_candidats <- n_min:n_max
  hauteur_marche <- hauteur_a_franchir / n_candidats
  ecart <- abs(hauteur_marche - h_ideale)

  res <- data.frame(
    n_marches = n_candidats,
    hauteur_marche = hauteur_marche,
    ecart_hauteur_ideale = ecart
  )

  res[order(res$ecart_hauteur_ideale), , drop = FALSE]
}
