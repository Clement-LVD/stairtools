#' Construit la géométrie complète d'un escalier, marche par marche
#'
#' Pour chaque contremarche (1 à \code{n_marches}), calcule sa position en x
#' (le giron cumulé des marches précédentes) et ses positions en y (bas/haut).
#' Accepte deux longueurs de \code{girons} :
#' \itemize{
#'   \item \code{n_marches - 1} : escalier classique, la dernière contremarche
#'     arrive directement sur le palier (pas de giron après elle) ;
#'   \item \code{n_marches} : une marche palière est ajoutée \strong{après} la
#'     dernière contremarche, à la même hauteur que le palier d'arrivée —
#'     donc jamais suivie d'une contremarche supplémentaire.
#' }
#'
#' Pensé pour être tracé directement avec \code{segments()} en base R :
#' \itemize{
#'   \item contremarche i (verticale) : de \code{(x_contremarche, y_bas)} à
#'     \code{(x_contremarche, y_haut)}
#'   \item giron i (horizontale), si non-NA : de \code{(x_contremarche, y_haut)}
#'     à \code{(x_fin_giron, y_haut)}
#' }
#'
#' @param n_marches Nombre de contremarches.
#' @param hauteur_marche Hauteur de marche uniforme (cm).
#' @param girons Vecteur des girons, de longueur \code{n_marches - 1}
#'   (escalier classique) ou \code{n_marches} (avec marche palière en extension).
#' @param type_girons Vecteur caractère de même longueur que \code{girons},
#'   décrivant le type de chaque giron (ex. "standard", "paliere").
#'   Défaut : tous "standard".
#'
#' @return Un \code{data.frame}, une ligne par contremarche, colonnes :
#'   \code{num_marche}, \code{x_contremarche}, \code{y_bas}, \code{y_haut},
#'   \code{giron}, \code{x_fin_giron}, \code{type_giron}.
#'
#' @examples
#' geo <- construire_geometrie(
#'   n_marches = 5, hauteur_marche = 17.33,
#'   girons = rep(28.33, 4)   # longueur n_marches - 1 : pas de marche palière
#' )
#' geo
#' plot(geo)  # équivalent à plot_escalier(geo), grâce à la classe escalier_geometrie
#'
#' @export
construire_geometrie <- function(n_marches, hauteur_marche, girons, type_girons = NULL) {

  n_treads <- length(girons)
  n_sans_extension <- n_marches - 1

  if (!(n_treads %in% c(n_sans_extension, n_marches))) {
    stop(sprintf(
      "length(girons) doit valoir n_marches - 1 (%d, escalier classique) ou n_marches (%d, avec marche palière en extension).",
      n_sans_extension, n_marches
    ))
  }

  if (is.null(type_girons)) {
    type_girons <- rep("standard", n_treads)
  } else if (length(type_girons) != n_treads) {
    stop("length(type_girons) doit correspondre à length(girons).")
  }

  if (n_treads == n_sans_extension) {
    girons <- c(girons, NA_real_)
    type_girons <- c(type_girons, NA_character_)
  }
  # à partir d'ici : girons et type_girons sont de longueur n_marches

  girons_pour_cumul <- ifelse(is.na(girons), 0, girons)
  x_contremarche <- c(0, cumsum(girons_pour_cumul))[seq_len(n_marches)]
  y_bas  <- (0:(n_marches - 1)) * hauteur_marche
  y_haut <- (1:n_marches) * hauteur_marche

  geometrie <- data.frame(
    num_marche     = seq_len(n_marches),
    x_contremarche = x_contremarche,
    y_bas          = y_bas,
    y_haut         = y_haut,
    giron          = girons,
    x_fin_giron    = x_contremarche + girons,
    type_giron     = type_girons,
    stringsAsFactors = FALSE
  )

  # Classe S3 dédiée : permet d'appeler plot(geometrie) directement (voir
  # plot.escalier_geometrie() dans plot_escalier.R) plutôt que d'obtenir le
  # pairs-plot par défaut de plot.data.frame().
  class(geometrie) <- c("escalier_geometrie", class(geometrie))
  geometrie
}

